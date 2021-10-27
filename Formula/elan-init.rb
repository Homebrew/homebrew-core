class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/v1.2.0.tar.gz"
  sha256 "98cb8978b5feb9383898714a5a34226789c1fddcedf9dc2e5ce01064c1d3fd34"
  license "Apache-2.0"
  head "https://github.com/leanprover/elan.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "b273b0d9f3f06d2a2a95ea32932ea31937d6d4f4071c9b30d498b26abd06f463"
    sha256 cellar: :any_skip_relocation, catalina:     "1a30f9ac0bfdee77f9d0f5e429551d241e39ac5796318a09895b5619220c7d79"
    sha256 cellar: :any_skip_relocation, mojave:       "ea9407979be2b4a7d8e917c4173c111994b147190759f3a3f185944158f80ed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "73365d7d377432859afa40a7eb0717ecd1f6157bfd471d4fc8e910fe4ee7e6e9"
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
