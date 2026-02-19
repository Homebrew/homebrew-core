class Audiowaveform < Formula
  desc "Generate waveform data and render waveform images from audio files"
  homepage "https://codeberg.org/chrisn/audiowaveform"
  url "https://codeberg.org/chrisn/audiowaveform/archive/1.11.0.tar.gz"
  sha256 "87f7422b823ccb1621d715010649a9b0c1a0ce9a4e4b26c2784cb7f2b94589f4"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a46708684e47e59c0c97f12730a79568473d70c20b198f17abf3f44e1419fc8"
    sha256 cellar: :any,                 arm64_sequoia: "0a29810f388e9252e30ae8ac65ab4b0382310a39496ee11968255c1faba91f8c"
    sha256 cellar: :any,                 arm64_sonoma:  "50d62cc5d859c9196359e1eb1b9e6bd4deb82848e45c2ccbdc57f59a19665c96"
    sha256 cellar: :any,                 sonoma:        "f84ec9bbc74481908f5686ebd04893e15e4d82d39d32b2b7f9f64c068290df07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4440a2064bf90b55931f98247825e9b1029385ee25b2e1665d0a9719174ecbc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be445bcb1ddc838feedf1d08780e30274e951596fd52b6979fc3eb033d099d66"
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
