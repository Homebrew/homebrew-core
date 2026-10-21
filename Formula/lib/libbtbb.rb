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
    rebuild 5
    sha256 cellar: :any, arm64_golden_gate: "d7317f944894023015d71a79cd6e3240a362d44c920078f51a159c1b1ee2f003"
    sha256 cellar: :any, arm64_tahoe:       "6d41477bc0a8536332c3dddb4b9f31032d792f47c3e711e5670dd35859d09568"
    sha256 cellar: :any, arm64_sequoia:     "204e74d4692d2bf1f9f51be4789d4911d05a476dd2c0b80e414cdcf23c5d401e"
    sha256 cellar: :any, arm64_linux:       "49f6e76ef06c5c80c4d74174c92c56ac5348e804b8013715f1990cc6de497290"
    sha256 cellar: :any, x86_64_linux:      "5f8109617f9cbf54f4c8891c66ba2e4dd1ca90165c5f85d1db8dcf4753903362"
  end

  depends_on "cmake" => :build
  depends_on "python@3.15"

  def install
    args = %w[-DENABLE_PYTHON=OFF]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./python/pcaptools"
    bin.install "python/pcaptools/btaptap"
    rewrite_shebang detected_python_shebang, bin/"btaptap"
  end

  test do
    system bin/"btaptap", "-r", test_fixtures("test.pcap")
  end
end
