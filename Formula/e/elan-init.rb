class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/v2.0.1.tar.gz"
  sha256 "f241cf15a8d18def76311862a5eea5b72d7fabd22bdf88397031e119d0675169"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0991578dc9c746c9858a46298b3da94cc91bbf284d6b8207d8923c6b9f7cbcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "184bf656bcf2cfa1455175aa78b1dd3055d89e190d64808b59568c0f5251e250"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c609a17e65dbf0db2748f90bc5d34bf544a65f2ad1b48419fe133f2521a213ca"
    sha256 cellar: :any_skip_relocation, ventura:        "9ca99995d526d6f78efdcbae07db35a13cbf3d64affbdd601180158fa79bd21d"
    sha256 cellar: :any_skip_relocation, monterey:       "fbbc17ec1c310f91e15b49cc3f6613327c2f8a1b2f799f993601ca5d7ad16136"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca3943b6a7e33dfc3fb3df7a0bd9b9638a5f031fadf122f5c48eef92a219b55e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b426f6a547f3f70f183b3a488eb7f8397502ef734d9e026d2b46203d6f048be6"
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
