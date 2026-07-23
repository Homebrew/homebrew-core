class Hss < Formula
  desc "Interactive parallel SSH client"
  homepage "https://github.com/six-ddc/hss"
  url "https://github.com/six-ddc/hss/archive/refs/tags/1.10.tar.gz"
  sha256 "570585d660e64ba29e574f68bae5f2e38905d9a5f6ce0e9e36d82c5342fddf2b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2bb2eb21cf15af087ab7ed8e764cc90fbdd452f1ea0e81c71d79a20cf099cc83"
    sha256 cellar: :any,                 arm64_sequoia: "ab1d14ee93ade63ab4f7ee790cfc4ef658871bc7be566039b0f99bda7830fb06"
    sha256 cellar: :any,                 arm64_sonoma:  "3606b82b29cd0c9de3db42b5089f1c8744a009fa229534100142a3091fd50f3e"
    sha256 cellar: :any,                 sonoma:        "04fe2ff9d6beae3e4f5b1774710410a31b301ff0617424c21798b784109f425b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98dd1270d4dae19983c37c4f415236e7a8ba168b5c6c2885552bc4c7639ded5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85d4b12a7f8b94e6394e8252d2b81230d96f1dd554bdf0d7669552ed93c52184"
  end

  depends_on "readline"

  def install
    system "make"
    system "make", "install", "INSTALL_BIN=#{bin}"
  end

  test do
    port = free_port
    begin
      server = TCPServer.new(port)
      accept_pid = fork do
        msg = server.accept.gets
        assert_match "SSH", msg
      end
      hss_read, hss_write = IO.pipe
      hss_pid = fork do
        exec bin/"hss", "-H", "-p #{port} 127.0.0.1", "-u", "root", "true",
          out: hss_write
      end
      server.close
      msg = hss_read.gets
      assert_match "Connection closed", msg
    ensure
      Process.kill("TERM", accept_pid)
      Process.kill("TERM", hss_pid)
    end
  end
end
