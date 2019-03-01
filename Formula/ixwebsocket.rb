class Ixwebsocket < Formula
  desc "WebSocket client and server, and HTTP client command-line tool"
  homepage "https://github.com/machinezone/IXWebSocket"
  url "https://github.com/machinezone/IXWebSocket/archive/v1.1.0.tar.gz"
  sha256 "52592ce3d0a67ad0f90ac9e8a458f61724175d95a01a38d1bad3fcdc5c7b6666"
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/ws", "--help"
    system "#{bin}/ws", "send", "--help"
    system "#{bin}/ws", "receive", "--help"
    system "#{bin}/ws", "transfer", "--help"
    system "#{bin}/ws", "curl", "--help"
  end
end
