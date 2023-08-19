class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https://github.com/obgm/libcoap"
  url "https://github.com/obgm/libcoap/archive/v4.3.1.tar.gz"
  sha256 "074a71deca01e06d3acb00a1416d0fbeb87d130f40a3c0f6fda3a5c711855dca"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3bad1beba15ee306b2b2f6245d889aef8c9477ce52f6eb5223338d1390b0e156"
    sha256 cellar: :any,                 arm64_monterey: "7dd5d4c8918ca7bf9f05c86d020ccfda6fd9cbab6770aa8b693c818b3c4155cc"
    sha256 cellar: :any,                 arm64_big_sur:  "876e1c10f9a7fab51e2462db44e95b23f1d8ac0085c9cfe02b11181ea64988f0"
    sha256 cellar: :any,                 ventura:        "71f33b9d774289ee9197f4b4cb6568051732abc784ec69ee550a8973c07b071c"
    sha256 cellar: :any,                 monterey:       "f275fc1b8e5aca8b3c179ab40d9a30058df7a501e62530dcd2f5fdf8d47e09c7"
    sha256 cellar: :any,                 big_sur:        "ff567b66ad0ad10162c4f54561a4a0eaf97fe562efb6ff6b68e72c3973b3177d"
    sha256 cellar: :any,                 catalina:       "b20f8aa33cdb7f91bff0215748b7c14f10952e7b03a3c56bb9f021209489afc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69dfa73e553e3aa8e22c312a8163b511cf2f495ec99f8d18e18790f4b40da08a"
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
