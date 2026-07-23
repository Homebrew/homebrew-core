class Audiowaveform < Formula
  desc "Generate waveform data and render waveform images from audio files"
  homepage "https://codeberg.org/chrisn/audiowaveform"
  url "https://codeberg.org/chrisn/audiowaveform/archive/1.11.1.tar.gz"
  sha256 "cf827d835efe4edb48c16f48be7a9502d7572c9d6f92f811af5238d64b36bda2"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "968b709cbfa7f4f8c17a8f573c2193864eba18df619113a52e6758614eab6f73"
    sha256 cellar: :any, arm64_sequoia: "f9d84f41bd03af27455fb5b9b9b03c94531f8f0dc89fe003d78a6396fab8d37a"
    sha256 cellar: :any, arm64_sonoma:  "3f4265859b7a730b38baafe4ca80cc4faf341d63a73aee1c6215e85452266069"
    sha256 cellar: :any, sonoma:        "c55d4c896a9d67648ea54300d4f9f94d7352d791c47b8a8fdbf083154aa50006"
    sha256 cellar: :any, arm64_linux:   "6d9da15bf0e3fbbe84cd19be5f11a9d1aae49229f54a98c480e5fbaa8e365390"
    sha256 cellar: :any, x86_64_linux:  "d2236e8dd6498b43db3dbcce8ad36ad64232715a5944a44886eb173b995ad58b"
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
