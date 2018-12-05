class Libbtbb < Formula
  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2018-12-R1.tar.gz"
  version "2018-12-R1"
  sha256 "0eb2b72e1c1131538206f1e3176e2cf1048751fe7dc665eef1e7429d1f2e6225"
  head "https://github.com/greatscottgadgets/libbtbb.git"

  bottle do
    cellar :any
    sha256 "94949c6626fc47d9879b00ab5f259a3bc09ffa3aab3b9be93c56e80cdb19d5db" => :mojave
    sha256 "e044f611d480089eb2206cfdb6d7289c33cd9043642f024270957e6ac3f2fa5f" => :high_sierra
    sha256 "ce36c7d48d1ca6ebf1087f2edab17be8ce4f381afe652f03a5fab0d6f6c9f7db" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"btaptap", "-r", test_fixtures("test.pcap")
  end
end
