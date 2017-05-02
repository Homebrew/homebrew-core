class Libbtbb < Formula
  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2017-03-R2.tar.gz"
  version "2017-03-R2"
  sha256 "2b3ea5f07b7022e862f367e8a9a217e1d10920aecdc4eba7b7309724fb229cfd"
  head "https://github.com/greatscottgadgets/libbtbb.git"

  bottle do
    cellar :any
    sha256 "d9bbae0f63e26ea0651c39fcb57e206152eb65a4e71f799decb28986679504db" => :sierra
    sha256 "3ba1e4a1d131161b4a06bfaad8935f4dab0728d88109aa0d9fbdd5844d7e0feb" => :el_capitan
    sha256 "03b875fe72f70e859bb298aa4a1bb4327ad4422a0f18e564aa2f72639baab592" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :python if MacOS.version <= :snow_leopard

  # Requires headers macOS doesn't supply.
  resource "libpcap" do
    url "http://www.tcpdump.org/release/libpcap-1.8.1.tar.gz"
    sha256 "673dbc69fdc3f5a86fb5759ab19899039a8e5e6c631749e48dcd9c6f0c83541e"
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
