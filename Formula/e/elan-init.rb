class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  stable do
    url "https://github.com/leanprover/elan/archive/refs/tags/v3.1.1.tar.gz"
    sha256 "b3e3c7dc6cc23dd319725fccf58c898bf4920ff3440c97cb8f3a35fc0d5bbf5c"

    # rust 1.80 build patch, upstream pr ref, https://github.com/leanprover/elan/pull/134
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/815affb24bff77daad4e99e31afed8de42a31312/elan-init/rust-1.80.patch"
      sha256 "244420efc73ba1fb4908023047fbb1650f783c30e73aa1facb82645d80c7136f"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9414f2c97133007a99261abfea1cb188f953939c0b62b85700b56e8042679461"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7aef59f7e264ecf7a2c856e2666e6aafd3ea7eace3eaf43437531490773e0102"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b82859cd41243cd8d4acfc1d28862c32261c4a9f588da90422641dd8992f8bea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dda8aedbfe1d28aa4d97b3269cf17088d0efa0843661e548c70c6b7615813db8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c6589bc32c581d6d3c614ea1b46ee3497d0859adae548ab2a732ecd1008dafa"
    sha256 cellar: :any_skip_relocation, ventura:        "efb5e621bf215f9c7061d05ca9f9b1fb251a0c270ea1d323cd5991606e897d93"
    sha256 cellar: :any_skip_relocation, monterey:       "bfcde921f1b585c26c5150a8cf258d6d5c752ce4d67cab58cafb742562de8e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45ca6bf10c24f0d45e7a81dfe66d94ae87b25ea61b0d635bbcaf46e1d20f153d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "coreutils"
  depends_on "gmp"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with "lean-cli", because: "both install `lean` binaries"
  conflicts_with "lean", because: "`lean` and `elan-init` install the same binaries"

  def install
    ENV["RELEASE_TARGET_NAME"] = "homebrew-build"

    system "cargo", "install", "--features", "no-self-update", *std_cargo_args

    %w[lean leanpkg leanchecker leanc leanmake lake elan].each do |link|
      bin.install_symlink "elan-init" => link
    end

    generate_completions_from_executable(bin/"elan", "completions")
  end

  test do
    ENV["ELAN_HOME"] = testpath/".elan"

    system bin/"elan-init", "-y", "--default-toolchain=leanprover/lean4:stable"
    (testpath/"hello.lean").write <<~EOS
      def id' {α : Type} (x : α) : α := x

      inductive tree {α : Type} : Type
      | node : α → List tree → tree

      example (a b : Prop) : a ∧ b -> b ∧ a := by
          intro h; cases h with
          | intro ha hb => constructor; exact hb; exact ha
    EOS
    system bin/"lean", testpath/"hello.lean"
    system bin/"lake", "help"
  end
end
