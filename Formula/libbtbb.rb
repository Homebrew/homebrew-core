class Libbtbb < Formula
  include Language::Python::Shebang

  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2020-12-R1.tar.gz"
  version "2020-12-R1"
  sha256 "9478bb51a38222921b5b1d7accce86acd98ed37dbccb068b38d60efa64c5231f"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/greatscottgadgets/libbtbb.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "36c467509eec45be4a17cb6c9146f56866f2b6a3f41c08166404f39944fa4621"
    sha256 cellar: :any,                 arm64_monterey: "1b9b2c8f1895afb52212f2564b5e538e7e2e17c58ed669015dd3e2f7ba668997"
    sha256 cellar: :any,                 arm64_big_sur:  "045cb3192c8dd4f487e972da2222a3ace4b93ab7b538cf61dd5b93836b2e1c17"
    sha256 cellar: :any,                 ventura:        "f0eecd7ea2b13216116d2c810367c42ec5172ff556d1330898b9f120263688d2"
    sha256 cellar: :any,                 monterey:       "f74c9cd2853b7fcfbdcf288265e5a77032b085bdb9b07edf75ba32daf3cc4f44"
    sha256 cellar: :any,                 big_sur:        "351fdb32609b85096a959d4511430584d3b5fef71f207e092cfb6e1007dd2488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "022b75cccc7cfc9ea9e18a5efb7c5bda3286d154d2952b2b0109530d509d2a39"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11"

  def install
    # setuptools>=60 prefers its own bundled distutils, which breaks the installation
    ENV["SETUPTOOLS_USE_DISTUTILS"] = "stdlib"

    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIX/lib since Python 3.10.
    site_packages = prefix/Language::Python.site_packages("python3.11")
    inreplace "python/pcaptools/CMakeLists.txt", "${OUTPUT} install ", "\\0 --install-lib=#{site_packages} "

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    rewrite_shebang detected_python_shebang, bin/"btaptap"
  end

  test do
    system bin/"btaptap", "-r", test_fixtures("test.pcap")
  end
end
