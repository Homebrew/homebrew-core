class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https://github.com/obgm/libcoap"
  url "https://github.com/obgm/libcoap/archive/v4.3.1.tar.gz"
  sha256 "074a71deca01e06d3acb00a1416d0fbeb87d130f40a3c0f6fda3a5c711855dca"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "9c223e0327a209a36f730296d7f8c3b31169fccb0ac1694c10c18ccd7678f31e"
    sha256 cellar: :any,                 arm64_monterey: "f5ab53c8913b63df31cb87635e43d03f98f85bca6957c8a6a4049e39ed6174fd"
    sha256 cellar: :any,                 arm64_big_sur:  "2756ec8bb7385c9ec8336de194a22e6442bd49eee9aff72b10bcbf378d4eeddb"
    sha256 cellar: :any,                 ventura:        "8bf6884a5e5fd902655f271158773b435769763f449e713d1cba27b33e86f5fe"
    sha256 cellar: :any,                 monterey:       "7e4043365c3df4efade4190fee51b4abad482f93c15f490ce8c0deeef43bdbfb"
    sha256 cellar: :any,                 big_sur:        "164bbd32151a0537ee38a227b197b1877398db08a6f5ad99d3120ba2e0629e4d"
    sha256 cellar: :any,                 catalina:       "4f7e4b320d8664bbdc4413c2d3407f3fc964f0aaba6a307d848eab61817d35ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bd4c6f410ad671a3a61c1386a4c9ced615dd5765d7b77cafd2ecce6f6a2ef04"
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
