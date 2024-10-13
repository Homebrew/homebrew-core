class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://github.com/geographiclib/geographiclib/archive/refs/tags/r2.4.tar.gz"
  sha256 "7b2a998c9a0917b49242671a7a6f5fe72e3e77d12f30de56142b1d7ea4dd4136"
  license "MIT"
  head "https://github.com/geographiclib/geographiclib.git", branch: "main"

  livecheck do
    url :stable
    regex(/^r(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "746853c7e7c21f91daefaf6c3acc507d7bc5a55b45a11fb2fbaeefe0d0d271a2"
    sha256 cellar: :any,                 arm64_sonoma:   "bbdf00fce67d80a32afe57759458c00905fb6115fb14350501664d661685ae31"
    sha256 cellar: :any,                 arm64_ventura:  "310c7924d42abd9e930c5fd446333629659c56fd7d9f7a91fdca699f8d4c1644"
    sha256 cellar: :any,                 arm64_monterey: "1a5b138450ed91a5a5efd87029a6d9df0bfc0cf22fb1ec9878e4ed354ceb3f94"
    sha256 cellar: :any,                 sonoma:         "c35d40824be79486629bd3941401be1728e626555680958d50e99622d84cd065"
    sha256 cellar: :any,                 ventura:        "f7b4188bdf63897c3e08748ec0696baa5683fc466753bcdbac2c3648bb76a97c"
    sha256 cellar: :any,                 monterey:       "c355cec2e5134d1c184b7bbae356234ed4a06e32f3b0bb7da98d0c53d47c0f63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "685905fa34a686d0776bc13efecf2355172e30df09342631e7d7b15414cd642c"
  end

  depends_on "cmake" => :build

  def install
    args = ["-DEXAMPLEDIR="]
    args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
