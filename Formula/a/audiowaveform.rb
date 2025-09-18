class Audiowaveform < Formula
  desc "Generate waveform data and render waveform images from audio files"
  homepage "https://waveform.prototyping.bbc.co.uk"
  url "https://github.com/bbc/audiowaveform/archive/refs/tags/1.10.3.tar.gz"
  sha256 "191b7d46964de9080b6321411d79c6a2746c6da40bda283bb0d46cc7e718c90b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0883230a730a658b0037ad1d4fd80a0843bfcbd6a1820bc463648429df5f216"
    sha256 cellar: :any,                 arm64_sequoia: "1e9fefd035443e96fc39605c249e618408b8d79852d8b635e4c73fa72633fd80"
    sha256 cellar: :any,                 arm64_sonoma:  "889c6dfe09ecd0e73ae9aa5640a09ea428b30f50f95a6e8c236d5bd810db65c4"
    sha256 cellar: :any,                 arm64_ventura: "d18a60880174cfcab31fffaccd30fd4d9599016abc57bea6876482300082cc18"
    sha256 cellar: :any,                 sonoma:        "4b0a4c44b31fb0d5d4053cdafc13b2f61a7b51511d7c76c5b853745a4ad73544"
    sha256 cellar: :any,                 ventura:       "03b9eb62b31e53d0aed8a618a3e73c402c816e936763a57d243fe536dcd74852"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ae6cd104cd3c23dccc7a19265ef3a44168abf208c45064a1788155564ad9394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "513241538f7c5d46a3f0b2830649ce4aab77aee49aa08966bf82d9039f829ae0"
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
