class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/v1.3.1.tar.gz"
  sha256 "8e1380a1cb20cec54f07e30519ad7bc0179d9e3d68d33c02d0476248322b5015"
  license "Apache-2.0"
  head "https://github.com/leanprover/elan.git"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "8e4ec81d30fc503b9e584012962ae689b97c7b39ad2a3f08be03162d1b8fd7b8"
    sha256 cellar: :any_skip_relocation, big_sur:      "72d7b850d01d2203c9c69c03466312085c92f9841aa6c5e94c760b21cbaf355b"
    sha256 cellar: :any_skip_relocation, catalina:     "242382ab38d52c7454779903b85f304dc0e4471dabc44769427faf7ed8ffcc5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c3de4ae75a6278bab2efe45b05d0423f3dce38c1aa42a0e11e7b6d86ffeac357"
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
