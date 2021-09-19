class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v1.1.6.tar.gz"
  sha256 "7f721c3498e9db2d9340d9ac50bb2561b2d2629415143a7742efd9c904b92000"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "540e6bea6a26e11fc2a2d2437c5eb2f2c8bcd0c441664c40d302d0582ed7ed09"
    sha256 cellar: :any_skip_relocation, big_sur:       "82827fe2b5740c73b2307c0768a3a756d1cae980588d3b6a342488bb3468e1e1"
    sha256 cellar: :any_skip_relocation, catalina:      "62a530a4aba386efca96ff3a14fca7f5c6a22357a37196f4479b2d57116ff074"
    sha256 cellar: :any_skip_relocation, mojave:        "64da5e83a4e28ceb7265de58a7b6ac3897aa6f55d7b922e268865303dbe39b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23b3fb92fc1b7861b8971ae7987ea1e9661bf1c74d608471057dfd19fbcbe98b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
