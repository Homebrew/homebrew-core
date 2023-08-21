class AdamstarkAudiofile < Formula
  desc "C++ Audio File Library by Adam Stark"
  homepage "https://github.com/adamstark/AudioFile"
  url "https://github.com/adamstark/AudioFile/archive/refs/tags/1.1.1.tar.gz"
  sha256 "664f9d5fbbf1ff6c603ae054a35224f12e9856a1d8680be567909015ccaac328"
  license "MIT"
  head "https://github.com/adamstark/AudioFile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "68015559df1d82a885ae9c86ce03e39ae00237fe2d63c2f85f12376fdffe0211"
  end

  def install
    include.install "AudioFile.h"
  end

  test do
    (testpath/"audiofile.cc").write <<~EOS
      #include "AudioFile.h"
      int main(int argc, char* *argv) {
        AudioFile<double> audioFile;
        AudioFile<double>::AudioBuffer abuf;
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++17",
           "-I#{include}",
           "-o", "audiofile",
           "audiofile.cc"
    system "./audiofile"
  end
end
