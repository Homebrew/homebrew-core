class Endlessh < Formula
  desc "SSH tarpit that slowly sends an endless banner"
  homepage "https://github.com/skeeto/endlessh"
  url "https://github.com/skeeto/endlessh/archive/refs/tags/1.1.tar.gz"
  sha256 "786cea9e2c8e0a37d3d4ecd984ca4a0ae0b2d6e2b8da37e3cdbb9d49ccdecbf0"
  license "Unlicense"
  head "https://github.com/skeeto/endlessh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffd3ea03702dd6fd5c23bbbb6d35861f3d1c8e970a240725698b64c28561e16f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "411d555a09129d69c5e541f858900beec6fa0ff9bdb61e2fa0948fd4d545cf6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1285873a9b0adb281b223cf5882c8c6db728d166e1d164098a4a72d955f84b30"
    sha256 cellar: :any_skip_relocation, sonoma:        "1843db59ceda7ca7621e2e75aacc879646b3879470ed8e6490ed87d44f56e562"
    sha256 cellar: :any_skip_relocation, ventura:       "74d2b7f51ca9545accd50203e78fe3302241f4b0213b3db6bf84c9b1be198f8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5138b259981ac0f9924e16a5e48a7338b9d5869e5455c5015074ec56f960e4a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cb6ceb337489733e34cdaec8bc65c95f115b020b00a9c2e371d8537938c0552"
  end

  uses_from_macos "netcat" => :test

  def install
    inreplace "endlessh.c", "/etc/endlessh/", "#{pkgetc}/"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    port = free_port
    pid = spawn(bin/"endlessh", "-p", port.to_s)

    sleep 5

    system "nc", "-z", "localhost", port
  ensure
    Process.kill "HUP", pid
  end
end
