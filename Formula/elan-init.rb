class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/v1.1.0.tar.gz"
  sha256 "c4212ed2754aca7feabac36ab4f70cceb238c4ce5dca2421eef6055b1caec577"
  license "Apache-2.0"
  head "https://github.com/leanprover/elan.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "1fcc905317acfe57f2756702d550ec6cc5b0d9fbbf5fbfee06b4923db87852b7"
    sha256 cellar: :any_skip_relocation, catalina:     "f0c7ddc386a07af18a4bc43e90c62d32d249c7be6321f74a706ef9f7319ac6d4"
    sha256 cellar: :any_skip_relocation, mojave:       "c180af2b98b335cf2912a7acc8520cb443be3655a9302d71fa078fa40cedb43d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "033776f7e9777fad48aaece617321e708a93d8c7881e76f86030d2910708ed79"
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

    %w[lean leanpkg leanchecker leanc leanmake elan].each do |link|
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
