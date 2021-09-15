class BatExtras < Formula
  desc "Bash scripts that integrate bat with various command-line tools"
  homepage "https://github.com/eth-p/bat-extras"
  url "https://github.com/eth-p/bat-extras/archive/refs/tags/v2021.08.21.tar.gz"
  sha256 "15b5be9f33e2eba6ca8f27870a98ed6920a015281039bc418dafdba2a684d366"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ef0479ac64740999c67d9ff77067f0d96e9111cfd037cd0ec19605d3b6b0c9b"
    sha256 cellar: :any_skip_relocation, big_sur:       "3ef0479ac64740999c67d9ff77067f0d96e9111cfd037cd0ec19605d3b6b0c9b"
    sha256 cellar: :any_skip_relocation, catalina:      "3ef0479ac64740999c67d9ff77067f0d96e9111cfd037cd0ec19605d3b6b0c9b"
    sha256 cellar: :any_skip_relocation, mojave:        "3ef0479ac64740999c67d9ff77067f0d96e9111cfd037cd0ec19605d3b6b0c9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c94dd7dd7e3d29f1493267a300b3d6a1f309560f341ec24990d708e3aca3759"
  end

  depends_on "bat"      => :test
  depends_on "ripgrep"  => :test

  def install
    system "./build.sh", "--prefix=#{prefix}", "--install"
  end

  test do
    system "#{bin}/prettybat < /dev/null"
    system bin/"batgrep", "/usr/bin/env", bin
  end
end
