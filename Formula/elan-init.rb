class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/v1.1.2.tar.gz"
  sha256 "0b5fbba9645ab53008f5836cb9998bdd4993a55fb5351f1267a3c98189ef2db4"
  license "Apache-2.0"
  revision 1
  head "https://github.com/leanprover/elan.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "81356fdb3dbec32c9183f72786485cf2cd422a820d7593ec6569dd472424e62c"
    sha256 cellar: :any_skip_relocation, catalina:     "e9b7fc85e40b218f52b37da67f1ed90e219a00dcd419dbd4cba41a6b212762cc"
    sha256 cellar: :any_skip_relocation, mojave:       "a63e897eefafac7a60c7d6453870dc6dc6368b8ed4246293b60d441dfe1d6dec"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "216d6bcf61836135ea758d197cd07ef5dc7cca483940dcab9d842cbe0b1955b8"
  end

  depends_on "rust" => :build
  # elan-init will run on arm64 Macs, but will fetch Leans that are x86_64.
  depends_on arch: :x86_64
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

    bash_output = Utils.safe_popen_read(bin/"elan", "completions", "bash")
    (bash_completion/"elan").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"elan", "completions", "zsh")
    (zsh_completion/"_elan").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"elan", "completions", "fish")
    (fish_completion/"elan.fish").write fish_output
  end

  test do
    system bin/"elan-init", "-y"
    (testpath/"hello.lean").write <<~EOS
      def id' {α : Type} (x : α) : α := x

      inductive tree (α : Type) : Type
      | node : α → list tree → tree

      example (a b : Prop) : a ∧ b -> b ∧ a :=
      begin
          intro h, cases h,
          split, repeat { assumption }
      end
    EOS
    system bin/"lean", testpath/"hello.lean"
    system bin/"leanpkg", "help"
  end
end
