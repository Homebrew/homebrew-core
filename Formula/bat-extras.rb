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
