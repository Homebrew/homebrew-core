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
    rebuild 4
    sha256 cellar: :any,                 arm64_tahoe:   "2546c5a279da682e9537ff11918430009f3eb3b66e431f596ce4d3b89eff1135"
    sha256 cellar: :any,                 arm64_sequoia: "7f4e5da4ab2a65a1380e90c86d34eb04ae0d741723e34abf8177ccefe4ea3a2e"
    sha256 cellar: :any,                 arm64_sonoma:  "5d3482171f8d473bb80e5b0f912c55e80f94d02603ead6867c82ebdbe5679422"
    sha256 cellar: :any,                 sonoma:        "b4149cbb04f90319f1e6208e8e2c8b3f84dfd4dc606f5e986e4a049ff364c64a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba2809209ffb2b0b04283d986308aedb24aa22ba33c0912991a7d28386181b15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "744108237f21bb9b38a34b0487a6c151d759d3a343244e916e11d83ceb180511"
  end

  depends_on "cmake" => :build
  depends_on "python@3.14"

  def install
    args = %w[-DENABLE_PYTHON=OFF]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "python3.14", "-m", "pip", "install", *std_pip_args(build_isolation: true), "./python/pcaptools"
    bin.install "python/pcaptools/btaptap"
    rewrite_shebang detected_python_shebang, bin/"btaptap"
  end

  test do
    system bin/"btaptap", "-r", test_fixtures("test.pcap")
  end
end
