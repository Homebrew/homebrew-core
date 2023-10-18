class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https://github.com/obgm/libcoap"
  url "https://github.com/obgm/libcoap/archive/v4.3.4.tar.gz"
  sha256 "ae61a48c21f7b40e1442c9e1da9aab9e6f2cf0deccb02f3fed4de232a0b0522e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c5318807d70629d11a4b4d66f3eb50ee7edba115141ada20e551b7780f80df78"
    sha256 cellar: :any,                 arm64_ventura:  "5be317341fa4f1116c8bde8a7a7228b6565b906a915e079cd11b2be8837b9f73"
    sha256 cellar: :any,                 arm64_monterey: "aced78b02de0f56db571a4fec3a43ba552ef55cd51c74c6b0d779a54ff732a13"
    sha256 cellar: :any,                 sonoma:         "7e7a9c9739409132a254b650e7f6b4511ed76f5b218630b437b1cf880bdc16f0"
    sha256 cellar: :any,                 ventura:        "be3732c2372e3ed2e45ade2f2f5accadb0d6ad119c274623ed8b61d807aba666"
    sha256 cellar: :any,                 monterey:       "c09e0bce7754763e69ca660fcb233339f396435985027ce270fab5922d065e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19c81e44ed492de2e8ea366ace3f52c88cadc1f19e5b60a4f98b8cc6b3b4a7e0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-examples",
                          "--disable-manpages"
    system "make"
    system "make", "install"
  end

  test do
    %w[coap-client coap-server].each do |src|
      system ENV.cc, pkgshare/"examples/#{src}.c",
        "-I#{Formula["openssl@3"].opt_include}", "-I#{include}",
        "-L#{Formula["openssl@3"].opt_lib}", "-L#{lib}",
        "-lcrypto", "-lssl", "-lcoap-3-openssl", "-o", src
    end

    port = free_port
    fork do
      exec testpath/"coap-server", "-p", port.to_s
    end

    sleep 1
    output = shell_output(testpath/"coap-client -B 5 -m get coap://localhost:#{port}")
    assert_match "This is a test server made with libcoap", output
  end
end
