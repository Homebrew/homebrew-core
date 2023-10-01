class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https://github.com/obgm/libcoap"
  url "https://github.com/obgm/libcoap/archive/v4.3.3.tar.gz"
  sha256 "3df6e1a51e42ef8fd45f16276505a47ed32aef150d348d60f251a0b470dda379"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "1ea3ea4ca1340cb2ca65bf3b51c6c50358e6872e65f038ac76248d84bf82ee9a"
    sha256 cellar: :any,                 arm64_ventura:  "d580428f27677c98234f1171468b3af17b6903b95b6767eec31949e3ff7b804e"
    sha256 cellar: :any,                 arm64_monterey: "017f40cb804950fd70584d910712be4bc69cadb28c2a7ce31b339c50c5733c1c"
    sha256 cellar: :any,                 arm64_big_sur:  "f1554992af4f5e8fcf912311e14adf5afadbeed43f06fb817ffa4a7c06b7fb84"
    sha256 cellar: :any,                 sonoma:         "b44d8a2d910abceaf71260605b963ab1988a808a374eb201126d3bd705dd9292"
    sha256 cellar: :any,                 ventura:        "3f92e8acf0c477578a1100307bc975018eb67df3cd638997b60fa962a1ba6b73"
    sha256 cellar: :any,                 monterey:       "53024969c090b3a9b09458541c51d4c631e959c8c1d91408e01981198cb6ed02"
    sha256 cellar: :any,                 big_sur:        "08694760319148b26549e9804c03387fe066ebddd207ad1c1005c8feb341dfe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d05e35a66268d91f351007eaff519083e34edc99449d03ab58e6a7064bb7f65"
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
