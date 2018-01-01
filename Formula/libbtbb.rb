class Libbtbb < Formula
  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2017-03-R2.tar.gz"
  version "2017-03-R2"
  sha256 "2b3ea5f07b7022e862f367e8a9a217e1d10920aecdc4eba7b7309724fb229cfd"
  head "https://github.com/greatscottgadgets/libbtbb.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3b83b0f80659a8e8e5f774f0c75e8de9e867397e6420cfc09d7640f6d816f65f" => :high_sierra
    sha256 "b7dc719910c8c6fe4a14bf016dd98a6e9aeff4163bcc2763ba79c1030cf60432" => :sierra
    sha256 "904bceae63d8ad367c07e90ffc095d0e3163bb45116b90bf1986791b030beb32" => :el_capitan
    sha256 "72fa7e942ce1fe4d7a2cc983bc79893b56924ebdd9076917db47c5b73408bb79" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "python" if MacOS.version <= :snow_leopard

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
