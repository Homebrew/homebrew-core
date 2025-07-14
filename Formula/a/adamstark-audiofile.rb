class AdamstarkAudiofile < Formula
  desc "C++ Audio File Library by Adam Stark"
  homepage "https://github.com/adamstark/AudioFile"
  url "https://github.com/adamstark/AudioFile/archive/refs/tags/1.1.3.tar.gz"
  sha256 "abc22bbe798cb552048485ce19278f35f587340bf0d5c68ac0028505eaf70dfe"
  license "MIT"
  head "https://github.com/adamstark/AudioFile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "be3c28ee81b69cd235ffdc3a9085037178558b2714b431781404b13d2a4cc5b3"
  end

  def install
    include.install "AudioFile.h"
  end

  test do
    (testpath/"audiofile.cc").write <<~CPP
      #include "AudioFile.h"
      int main(int argc, char* *argv) {
        AudioFile<double> audioFile;
        AudioFile<double>::AudioBuffer abuf;
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17",
           "-I#{include}",
           "-o", "audiofile",
           "audiofile.cc"
    system "./audiofile"
  end
end
