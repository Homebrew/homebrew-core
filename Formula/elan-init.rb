class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/v2.0.0.tar.gz"
  sha256 "defa9272887312038e4154aea0ab7e6864eb08ac10aa815616aa06569d1b32a1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "922eb16e8b873e80c2a8e7665ae4d25514274505eb5e49b5e7a1b5abcdfa4d2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8978f9235eab1abfd8a258714e3faf572ed6ec8ea20620d8cef1cef5879092c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab4c9bed32178a66e9a2f72eca5c9aa1f898ed601a2437222273a5a49eca6f16"
    sha256 cellar: :any_skip_relocation, ventura:        "96ace0162aaedbd83ff39d13b29f9d7486e25159e57989185e17699fcb1e4519"
    sha256 cellar: :any_skip_relocation, monterey:       "fded3f63246bab5986c81603c06416dbe449b46f8e1d44fc0db248bdc7a55409"
    sha256 cellar: :any_skip_relocation, big_sur:        "6eeb8e6ec7d3038a7911e3dddc1bdbec6fd6501db99e461d630e731285553dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49ef4320a0b252da1039d8f00fd8f25c237d4e4e9900b349a08e5b025dd1e5bc"
  end

  depends_on "rust" => :build
  depends_on "coreutils"
  depends_on "gmp"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

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
