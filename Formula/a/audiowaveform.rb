class Audiowaveform < Formula
  desc "Generate waveform data and render waveform images from audio files"
  homepage "https://codeberg.org/chrisn/audiowaveform"
  url "https://codeberg.org/chrisn/audiowaveform/archive/1.11.1.tar.gz"
  sha256 "cf827d835efe4edb48c16f48be7a9502d7572c9d6f92f811af5238d64b36bda2"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9172fdfdb61944eb65e4e0a77811ef0b15ab19e5dab5b69562517de137ab1be7"
    sha256 cellar: :any, arm64_sequoia: "49a5359ac7e0da2120e27fef9b050469ad5da4e7545beaf710b93e4fe72f7505"
    sha256 cellar: :any, arm64_sonoma:  "2d246ebc85a71145b347c8f34651547e1225e57e4d0847c74fccfc148c8ea461"
    sha256 cellar: :any, sonoma:        "4d9d1e23e0ce06f6893579ef1bdad1281ba0105411136801ac1c3af2f09b9436"
    sha256 cellar: :any, arm64_linux:   "ca72f938578beb11f855aa227a6d240c791472c5c6b7c5fef75406ff564d8006"
    sha256 cellar: :any, x86_64_linux:  "00f8ff508d51d82d730cde316f326bb1b0a6ecb0563d72ac2c3de2540c4cc59e"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gd"
  depends_on "libid3tag"
  depends_on "libsndfile"
  depends_on "mad"

  def install
    cmake_args = %w[-DENABLE_TESTS=OFF]
    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"audiowaveform", "-i", test_fixtures("test.wav"), "-o", "test_file_stereo.png"
    assert_path_exists testpath/"test_file_stereo.png"
  end
end
