class Dromeaudio < Formula
  desc "Small C++ audio manipulation and playback library"
  homepage "https://github.com/joshb/dromeaudio/"
  url "https://github.com/joshb/DromeAudio/archive/v0.3.0.tar.gz"
  sha256 "d226fa3f16d8a41aeea2d0a32178ca15519aebfa109bc6eee36669fa7f7c6b83"
  license "BSD-2-Clause"
  head "https://github.com/joshb/dromeaudio.git"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "56127ff9fdb552e5a521d52a9a848ddf1f4a79029740d65f053ba9cc8ab2c7f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "ef9ce724d04545c565e1e46f06560128f54c8fd164fdc3d3abca18a4d17ad9b6"
    sha256 cellar: :any_skip_relocation, catalina:      "5199ecfbb8454f1560685c537b1fbaf1b301b39ad8ea825a9f846cc9f3530f30"
    sha256 cellar: :any_skip_relocation, mojave:        "062b0fa8e43363d60e5816343d1fcb7f58ce02c236512d96f4bf4ba10c96fd2c"
    sha256 cellar: :any_skip_relocation, high_sierra:   "1334685c021a520567e2d16bfe68ebddea8f9382a50645e241d09349cfb6b450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f070aab40ff55d1bc82cae306c222e05770d9b5cd22fdace7fbb7d04ea7aa6f"
  end

  depends_on "cmake" => :build

  def install
    # install FindDromeAudio.cmake under share/cmake/Modules/
    inreplace "share/CMakeLists.txt", "${CMAKE_ROOT}", "#{share}/cmake"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_predicate include/"DromeAudio", :exist?
    assert_predicate lib/"libDromeAudio.a", :exist?

    # We don't test DromeAudioPlayer with an audio file because it only works
    # with certain audio devices and will fail on CI with this error:
    #   DromeAudio Exception: AudioDriverOSX::AudioDriverOSX():
    #   AudioUnitSetProperty (for StreamFormat) failed
    #
    # Related PR: https://github.com/Homebrew/homebrew-core/pull/55292
    assert_match(/Usage: .*?DromeAudioPlayer <filename>/i,
                 shell_output(bin/"DromeAudioPlayer 2>&1", 1))
  end
end
