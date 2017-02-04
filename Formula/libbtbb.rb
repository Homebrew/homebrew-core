class Libbtbb < Formula
  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2015-10-R1.tar.gz"
  version "2015-10-R1"
  sha256 "95f493d379a53ec1134cfb36349cc9aac95d77260db4fdb557313b0dbb5c1d5a"
  revision 1

  head "https://github.com/greatscottgadgets/libbtbb.git"

  bottle do
    cellar :any
    sha256 "ca2e1d20b1861ab016128590c98a8195a9d6acb581f997135fe174cd87d6cf33" => :sierra
    sha256 "0775b81b4e7620a5030090a0a449d5be11fdb0bd02d37c4ee5fff87670c44ec3" => :el_capitan
    sha256 "0ccf46429a2bddd4a71aeaaf24df9dc85c34f1c64062059ed0e630b551fcddd2" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :python if MacOS.version <= :snow_leopard

  # Requires headers macOS doesn't supply.
  resource "libpcap" do
    url "http://www.tcpdump.org/release/libpcap-1.7.4.tar.gz"
    sha256 "7ad3112187e88328b85e46dce7a9b949632af18ee74d97ffc3f2b41fe7f448b0"
  end

  def install
    resource("libpcap").stage do
      system "./configure", "--prefix=#{libexec}/vendor", "--enable-ipv6"
      system "make", "install"
    end

    ENV.prepend_path "PATH", libexec/"vendor/bin"
    ENV.append_to_cflags "-I#{libexec}/vendor/include"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"btaptap", "-r", test_fixtures("test.pcap")
  end
end
