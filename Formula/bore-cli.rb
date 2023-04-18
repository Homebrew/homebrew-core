class BoreCli < Formula
  desc "Modern, simple TCP tunnel in Rust that exposes local ports to a remote server"
  homepage "https://github.com/ekzhang/bore"
  url "https://github.com/ekzhang/bore/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "707459f6fde45139741d039910a1ec5095739ac31ed9b447c46624d71b1274b3"
  license "MIT"
  head "https://github.com/ekzhang/bore.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6edbfb09b9e6e21689d08cceecf988fe00dac7f4647a658578cb65dd603c85d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "304093791d0143ed8dd62c78de29a43578a0a0e9d378b2b93523351b7c674327"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32cc03ab79420e849a1997bb55b3d8f951bcb70ebb1840c92a83ff4446137642"
    sha256 cellar: :any_skip_relocation, ventura:        "1473a1140befada8a22394096192d623e538bfb0326c07695ab3e5cd256eed9a"
    sha256 cellar: :any_skip_relocation, monterey:       "b528f1f77d6afbc20803c94378b8f25e5dfa6b305fe3de677abec629cfbf2032"
    sha256 cellar: :any_skip_relocation, big_sur:        "2027a1f499b7b624e38f1d89a076fa5a1a893e8f7c47941b9bf01a3d690b6f87"
    sha256 cellar: :any_skip_relocation, catalina:       "c8369c6b80646f4cb337414689f46149a8a1bdf9e2837e77a9d3bfb40ec55c69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9957b6c7068a47e0af6cec938ee33058edc3154e751687646165e56d7bdea6e4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    _, stdout, wait_thr = Open3.popen2("#{bin}/bore server")
    assert_match "server listening", stdout.gets("\n")

    assert_match version.to_s, shell_output("#{bin}/bore --version")
  ensure
    Process.kill("TERM", wait_thr.pid)
    Process.wait(wait_thr.pid)
  end
end
