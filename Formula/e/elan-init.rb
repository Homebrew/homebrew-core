class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "b3e3c7dc6cc23dd319725fccf58c898bf4920ff3440c97cb8f3a35fc0d5bbf5c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be718756f24a38dfc2fdeabb6c1a8faa762f54e26bd7ba6c46a73ca6e7242a83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3eb50c0b149c00a1b4cdaeffe3083d9ed651e1db257a73f497ffb0328cfb33c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e087e76a080ff632b3873e6fdcf490021d0708984c95c736d9e837dad82fd08f"
    sha256 cellar: :any_skip_relocation, sonoma:         "f86a70914dac7f2cc72b4f7e8fa0e5a6833f38e1e0d407061f52f02014d6c297"
    sha256 cellar: :any_skip_relocation, ventura:        "468fe8ba4bdfac9eb73ff28e27ae164028640a3ccde8bea22073f2ac08ee352e"
    sha256 cellar: :any_skip_relocation, monterey:       "5a7e351d4f81b94d2e6538e41090c70f87ae125ca421dc59d586be3b2dca41a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9351bed83126cf13aba8e95e1dcf4fd2dc9b477381b10fe41929f248b1cba8e3"
  end

  depends_on "rust" => :build
  depends_on "coreutils"
  depends_on "gmp"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  conflicts_with "lean-cli", because: "both install `lean` binaries"
  conflicts_with "lean", because: "`lean` and `elan-init` install the same binaries"

  def install
    ENV["RELEASE_TARGET_NAME"] = "homebrew-build"

    system "cargo", "install", "--features", "no-self-update", *std_cargo_args

    %w[lean leanpkg leanchecker leanc leanmake lake elan].each do |link|
      bin.install_symlink "elan-init" => link
    end

    generate_completions_from_executable(bin/"elan", "completions", base_name: "elan")
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
