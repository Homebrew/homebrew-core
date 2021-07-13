class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.8.3.tar.gz"
  sha256 "cf48d52d20a12e11a3a6afd436a75550e78fc39c358e85a75caa08b39e4e75c6"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "be00245c46b59102dd8137e57d9a040bb19e570697968a46bccac1e40160f75b"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d9082ceeb39d5eea1d05a3ca589aa3edfdca89bfd833b2f2d5c6fbe8a09a1bb"
    sha256 cellar: :any_skip_relocation, catalina:      "9e613f07aeec747ed8d5af0e96c19274a4b3a1cf779bb3c96d30f17a2afc4aa0"
    sha256 cellar: :any_skip_relocation, mojave:        "a15d0f20ba032f9e438e799347646167b9a0f4ad74c607d4ff25e204fc27ee50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cbcb47e5c130557888f1c8ccf1c18a36d903d24f50afb95b2eedc55f6ea29db"
  end

  depends_on "rust" => :build
  uses_from_macos "llvm"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etc/completion/completion.bash" => "delta"
    zsh_completion.install "etc/completion/completion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
