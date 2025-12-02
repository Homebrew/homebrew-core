class Audiowaveform < Formula
  desc "Generate waveform data and render waveform images from audio files"
  homepage "https://codeberg.org/chrisn/audiowaveform"
  url "https://codeberg.org/chrisn/audiowaveform/archive/1.10.3.tar.gz"
  sha256 "f33680a4c74a718648ee0567511537ad80e015fb3bf5c8440a8176414afb415a"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "40d9bf787e5f7813ed51079d59716a7f88c6cd2c0076dc04b5838bf0d769536d"
    sha256 cellar: :any,                 arm64_sequoia: "0847aa9b5ae424d084e9ca3b8d00e703d1935237fe107ac87495ddf3301e360c"
    sha256 cellar: :any,                 arm64_sonoma:  "0edef92eb11576b39b7b4684c5c853a6e3e42b3784870d1e57406256c8baa110"
    sha256 cellar: :any,                 sonoma:        "93f324ec4b218cda6afb1459b53efe02d5a1887a1494831b89bcb753749ed752"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5832d40c71610ac220ad80dc716d252108916ad7f2b421f147d185c94ff7e7e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5be140b85eb627cbb179bfc6252d6af35f80dd9972b67426687af659e88a8996"
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
