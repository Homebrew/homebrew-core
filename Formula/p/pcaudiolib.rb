class Pcaudiolib < Formula
  desc "Portable C Audio Library"
  homepage "https://github.com/espeak-ng/pcaudiolib"
  url "https://github.com/espeak-ng/pcaudiolib/releases/download/1.3/pcaudiolib-1.3.tar.gz"
  sha256 "e8bd15f460ea171ccd0769ea432e188532a7fb27fa73ec2d526088a082abaaad"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "797c5e0ec4adb982e3efbcb3ff386d0ad3bbe212e731ce88375002cc6d0cf72d"
    sha256 cellar: :any,                 arm64_sequoia: "9581956c3f6ac62ed80312bad32f93be3bda767e7fb6ce251c600971371bbdd8"
    sha256 cellar: :any,                 arm64_sonoma:  "bd84f4e1511c570a34e372cf8f4532e92e9eaea2089e0a93d387f191d5c36845"
    sha256 cellar: :any,                 arm64_ventura: "3d8b34973b1a08cf739c4b7ce2c6a5b80dbfb3856d5777c5f26d4b9011b62bff"
    sha256 cellar: :any,                 sonoma:        "48118ebffee0146173486843027d4b5a07c8dd0c7be2a17a8fac5de80aebf6f8"
    sha256 cellar: :any,                 ventura:       "cc9fdf752114a5959fd6906ecd9b2bf182eea8eae5a43769ba6434e3679d6d2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f2763bfa17d7805667730aeff7bcdc00f649d41e82e51415ad36b2a135da6dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "103253ad42ee7905b3f45cba3c1fdfc646aca631b912f1346589e7f79e916fd4"
  end

  head do
    url "https://github.com/espeak-ng/pcaudiolib.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <pcaudiolib/audio.h>

      int main() {
        struct audio_object *my_audio = create_audio_device_object(NULL, "test", "test");
        int error = audio_object_open(my_audio, AUDIO_OBJECT_FORMAT_S16LE, 22050, 1);
        if (error != 0)
          printf("audio_object_open error: %s", audio_object_strerror(my_audio, error));
        audio_object_close(my_audio);
        audio_object_destroy(my_audio);
        return error;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lpcaudio"
    system "./test"
  end
end
