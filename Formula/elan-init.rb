class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/v1.4.2.tar.gz"
  sha256 "d15dc93575601224b73c4744c27f28cb118655659b20d444e93ed63ba30b7def"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2432326f07e61667f39867c44eac824557379d262c6c140d1600ee0dd937f6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e52f1a84a49c534d5ff41b9c24416879d66cb55b31fa7d2fd935ce6d566a31a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f778e3306dc0fcbe633acddb7c710808568686e85c41b0699b295f5e627ab0b"
    sha256 cellar: :any_skip_relocation, ventura:        "65c94821a4ce233c8b19e3363f021eb085048db398cb91d41a20daa3991813d9"
    sha256 cellar: :any_skip_relocation, monterey:       "36355bf225628abd9a8397e718a58f36b7b89f2b14b2ec590dd3b6a832575a7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "aeb5d93076e2db77f6494a0eb64ce3b7e029f309ba26e2a53b7af68248daf2d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9dd9d9be003ac6a6f9c72ce9f0db18066ea68bcfd87185c01eed0cc5ad9189c"
  end

  depends_on "rust" => :build
  depends_on "coreutils"
  depends_on "gmp"

  uses_from_macos "zlib"

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
