class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/v1.2.0.tar.gz"
  sha256 "98cb8978b5feb9383898714a5a34226789c1fddcedf9dc2e5ce01064c1d3fd34"
  license "Apache-2.0"
  head "https://github.com/leanprover/elan.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "2181bb8f337d31fbffa87af156612cb50530210cca172252ee3fa230d898a9e8"
    sha256 cellar: :any_skip_relocation, catalina:     "29ef8b2bf259c838777155a17d67e886b812acbbf215d30af397e53f7c618f52"
    sha256 cellar: :any_skip_relocation, mojave:       "9d5deb10df667f42c10ae2fb4260bbadadfb8e10823f17042bde7faab4f44a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "627be621b9fbe13a3c5a3b843d91efa453d476c3e5e976f14acb4d95a782a32f"
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
