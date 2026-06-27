class Audiowaveform < Formula
  desc "Generate waveform data and render waveform images from audio files"
  homepage "https://codeberg.org/chrisn/audiowaveform"
  url "https://codeberg.org/chrisn/audiowaveform/archive/1.11.1.tar.gz"
  sha256 "ee6d9ff7fa15a44fde31efe1a1c3d8443b0508f6c827237b9d743150605de516"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "605c6c0525c6d6d6bf7ac817becfc7d10c618432a6bf31a814c608c38bc1b0f0"
    sha256 cellar: :any,                 arm64_sequoia: "ecd72cb74e3a670f4a268ca3ccd4f3a89d622a6261b4e86156a509edbd31723b"
    sha256 cellar: :any,                 arm64_sonoma:  "a46385af4b7f97f081d4a4099ecbb3937056d4a449e73128253e3dca1b9d17f4"
    sha256 cellar: :any,                 sonoma:        "b65001da5f4acb902d62002196ac191aa8c473378df725348d7e9d9d668846ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca10864e1ed9ff3cb31463d9a5d6463740fcecd3cc0c8ef2f0f6d1514289d11b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0521c882c1d9f0bd62b5d9a5a4f97c4b86725cbca65df7ece44ed8f4f2b9a25"
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
