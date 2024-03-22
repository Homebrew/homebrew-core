class Libbtbb < Formula
  include Language::Python::Shebang

  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/refs/tags/2020-12-R1.tar.gz"
  version "2020-12-R1"
  sha256 "9478bb51a38222921b5b1d7accce86acd98ed37dbccb068b38d60efa64c5231f"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/greatscottgadgets/libbtbb.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "6a8d435f557ff501f185e5210afa482aec2fa60c91174659590baa3e0bae81e0"
    sha256 cellar: :any,                 arm64_ventura:  "917631db529c0c099316eabaf82b5913a46c928717b86ea83f7ca3468ce1c1f6"
    sha256 cellar: :any,                 arm64_monterey: "ad06c3de65ee9278e7ee01c6b031d0da7f3e983c1cd11555d270ab216c1aac34"
    sha256 cellar: :any,                 sonoma:         "da1230775d4adc0fe43ebd1800f8f30c8a65467d6fc4cfa127bc84f5f554dabb"
    sha256 cellar: :any,                 ventura:        "4f34330ad301c24c5cc2afdf781fd17663a571a72fd6888523c4f61d46bb963e"
    sha256 cellar: :any,                 monterey:       "3221dcf2bd421184e7c647a2573cbc74f0083d9421ddb8994cff38203d84bec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "295956e1e9db910945434b4149530ddd97a5e38ccf96b9673a15ae34426fbc13"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DENABLE_PYTHON=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "python3.12", "-m", "pip", "install", *std_pip_args(build_isolation: true), "./python/pcaptools"
    bin.install "python/pcaptools/btaptap"
    rewrite_shebang detected_python_shebang, bin/"btaptap"
  end

  test do
    system bin/"btaptap", "-r", test_fixtures("test.pcap")
  end
end
