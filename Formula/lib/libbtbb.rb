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
    rebuild 3
    sha256 cellar: :any,                 arm64_sequoia: "64901cfb8edd8d6ccbb685335ef735d0de585d4e2d82b246a9e720fde31a60cb"
    sha256 cellar: :any,                 arm64_sonoma:  "e726852f1f39301c67986c7b6dbfb0c182b8c5fb409c59a0c0cae4f3871ce0bb"
    sha256 cellar: :any,                 arm64_ventura: "cf6b1a34c31a753e2ff677dad8b5668c05a3c7f857ab4d961e8ed5218b83313c"
    sha256 cellar: :any,                 sonoma:        "9328d6ce06defac48d51045a420021f25b7ce7165c766d702c14611ae8c2fc92"
    sha256 cellar: :any,                 ventura:       "f82f1bcc5ad54c8fc3c86295050bcab0f570b99904f1582464b6c0131d10cc5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85e0a063f6196f8022335ecb838bfc169e2116533ced2ac80b510bb032694507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb29f005dbfc0f47754c839a37d3812f1c872409e7918426c5e1ed9bf345d744"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DENABLE_PYTHON=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "python3.13", "-m", "pip", "install", *std_pip_args(build_isolation: true), "./python/pcaptools"
    bin.install "python/pcaptools/btaptap"
    rewrite_shebang detected_python_shebang, bin/"btaptap"
  end

  test do
    system bin/"btaptap", "-r", test_fixtures("test.pcap")
  end
end
