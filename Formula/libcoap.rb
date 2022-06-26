class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https://github.com/obgm/libcoap"
  url "https://github.com/obgm/libcoap/archive/v4.3.0.tar.gz"
  sha256 "1a195adacd6188d3b71c476e7b21706fef7f3663ab1fb138652e8da49a9ec556"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "76d9f7fd3f8d00e43c75bf88360d7da28ec62ab5185e728cf19438b3bd79aa49"
    sha256 cellar: :any,                 arm64_big_sur:  "57300cff98f6ad59e6c4cf95de26bf0a4dbcf0fb64d2d911d6bdddadf63da1dc"
    sha256 cellar: :any,                 monterey:       "7f5739f30b40e5df1af1ffb15fbfc81402d0fd9bfd457e027ce7f7715647ff1b"
    sha256 cellar: :any,                 big_sur:        "f82b84bbe8f8db3b33810627b2a6d68462fc93a82daa6385a79afe7738534ae5"
    sha256 cellar: :any,                 catalina:       "4e2fa796da56bec1271a091dc6262b812ece25b989c62be4e4d4d08943dfbe7d"
    sha256 cellar: :any,                 mojave:         "09ad4d7b446860842318c4f21a4ee112e1dda916a36f9023811d7abb7bd66001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46a37f7b8518d442a2d1781a0d794d8725e9417d8009daff0fe0771282c3fc4d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

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
        "-I#{Formula["openssl@1.1"].opt_include}", "-I#{include}",
        "-L#{Formula["openssl@1.1"].opt_lib}", "-L#{lib}",
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
