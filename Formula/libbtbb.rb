class Libbtbb < Formula
  include Language::Python::Shebang

  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2020-12-R1.tar.gz"
  version "2020-12-R1"
  sha256 "9478bb51a38222921b5b1d7accce86acd98ed37dbccb068b38d60efa64c5231f"
  license "GPL-2.0-or-later"
  head "https://github.com/greatscottgadgets/libbtbb.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "45af5280dbcd75c003d97e75350a8aa409750686ecad10a5dc38b99e9a63790d"
    sha256 cellar: :any, big_sur:       "79cd35b4013959310c4a2bfc09512ea30814edc9d2a186cababe4f854ae11364"
    sha256 cellar: :any, catalina:      "a44e009e65047628a6d6c1e355ab19ca43410eaec83a557c907b277de361b98e"
    sha256 cellar: :any, mojave:        "835f6edfd8143b29d96eeeed66dd443d837cc8a117519fdca30637c417c9b8d9"
    sha256 cellar: :any, high_sierra:   "b2be1cc3b707870e022401656041307bfde41035659db8eee563647f0dce5873"
    sha256 cellar: :any, sierra:        "e09299efc9ea3b989a2b1ceda4d123e6cebec6b28aa8ff08cf3052dfa6a65c3d"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    rewrite_shebang detected_python_shebang, bin/"btaptap"
  end

  test do
    system bin/"btaptap", "-r", test_fixtures("test.pcap")
  end
end
