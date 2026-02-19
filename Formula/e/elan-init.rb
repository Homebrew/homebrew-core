class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/refs/tags/v4.1.2.tar.gz"
  sha256 "7d31b3d1d69857b11611363bd94bfdc4f0525a85077f20f823abf65b39ccc350"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fe03875d9ac34c3e777ca2bf9d4a733d152ca125269768446363ec343e71581"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2d378f15d7b9ed90f5d6be53d3689cd8f3ced566da390ee6a3117fa2a1ef8d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc43e3f82138c27a5648850fa270b594cf8b6b71f2f7aa5399385ca1793a10ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0cc946286aa0454fed0788db0cc3b815f8a151c3654738fbfe6cf5f26344641"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbfc946dda022c9eafaf66e789f90c0a53aa19043be6d0ae083b3435777b0297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f200ffdd1fea690fa1669a62685cfaaf27df00b3b305cfbaf2f8a58cdc9edef"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "coreutils"
  depends_on "gmp"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "xz"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "lean-cli", because: "both install `lean` binaries"

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
