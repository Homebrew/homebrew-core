class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https://github.com/obgm/libcoap"
  url "https://github.com/obgm/libcoap/archive/refs/tags/v4.3.4a.tar.gz"
  version "4.3.4a"
  sha256 "45f1aabbb5f710e841c91d65fc3f37c906d42e8fc44dd04979e767d3960a77cf"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2838cc25f928d4364af73515af2793c3e0cc101cdeb341a349261af6245e90fd"
    sha256 cellar: :any,                 arm64_ventura:  "a3e4f7f5076a275eddc953414e7ebef21ab7bc1de31dd9e7f8807803d32325e5"
    sha256 cellar: :any,                 arm64_monterey: "d31e6ee6218f56fa932f1d281275cace2b74bd93417ab77c9155d8b616c6822e"
    sha256 cellar: :any,                 sonoma:         "25f96ff147ca6109379284a132216026e6b8c2e26b5d704be4d23b2a4718de01"
    sha256 cellar: :any,                 ventura:        "09fc71d739f47c175bb2be5c5ec76c00b013537d6d45477676f5b02908451a0b"
    sha256 cellar: :any,                 monterey:       "6b4f746b5c9da80cd199c36a7f1154b7fd51755915f64caf4923fe463421c601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52d304c37828623c62c1c1f400f01ee2442ef19ff3d726a44c3de9778ad624ae"
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
