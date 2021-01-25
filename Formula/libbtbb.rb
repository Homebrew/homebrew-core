class Libbtbb < Formula
  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2018-12-R1.tar.gz"
  version "2018-12-R1"
  sha256 "0eb2b72e1c1131538206f1e3176e2cf1048751fe7dc665eef1e7429d1f2e6225"
  license "GPL-2.0"
  head "https://github.com/greatscottgadgets/libbtbb.git"

  bottle do
    cellar :any
    sha256 "79cd35b4013959310c4a2bfc09512ea30814edc9d2a186cababe4f854ae11364" => :big_sur
    sha256 "45af5280dbcd75c003d97e75350a8aa409750686ecad10a5dc38b99e9a63790d" => :arm64_big_sur
    sha256 "a44e009e65047628a6d6c1e355ab19ca43410eaec83a557c907b277de361b98e" => :catalina
    sha256 "835f6edfd8143b29d96eeeed66dd443d837cc8a117519fdca30637c417c9b8d9" => :mojave
    sha256 "b2be1cc3b707870e022401656041307bfde41035659db8eee563647f0dce5873" => :high_sierra
    sha256 "e09299efc9ea3b989a2b1ceda4d123e6cebec6b28aa8ff08cf3052dfa6a65c3d" => :sierra
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
