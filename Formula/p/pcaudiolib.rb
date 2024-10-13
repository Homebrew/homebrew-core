class Pcaudiolib < Formula
  desc "Portable C Audio Library"
  homepage "https://github.com/espeak-ng/pcaudiolib"
  license "GPL-3.0-or-later"

  stable do
    url "https://github.com/espeak-ng/pcaudiolib/releases/download/1.2/pcaudiolib-1.2.tar.gz"
    sha256 "6fae11e87425482acbb12c4e001282d329be097074573060f893349255d3664b"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d713da35af3fee0aeb5bb86719b8b544b4cf614df473090b93b579f0b9b47630"
    sha256 cellar: :any,                 arm64_sonoma:   "93e464880ad92fe6d01a9d7ae289de1d651e754bd7dc73ff36f997e440690ef4"
    sha256 cellar: :any,                 arm64_ventura:  "d4d3d51973306d23db005641d4ff0bf7fa253f45e40a6eb257d3444822aa5f4f"
    sha256 cellar: :any,                 arm64_monterey: "e869b2820a0891d695690497ed88f6f82e59d2c42abb9d384367fef1815cf111"
    sha256 cellar: :any,                 sonoma:         "d7397d64207e96b166f20e90ed93be29644946a6b35437af9b002e60e94d93f6"
    sha256 cellar: :any,                 ventura:        "f905d01515df1bb7babc8eae222534fbde844979d6ffd596a5ed71c89db93b31"
    sha256 cellar: :any,                 monterey:       "1b2d24e3561a8008d5b5c13aa903759db76c6dbe96953a5865a651cbee4a5d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c3de7e6ac9b806793767db2b2d9ded8152a1909ba4254215b3508251a346d55"
  end

  head do
    url "https://github.com/espeak-ng/pcaudiolib.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lpcaudio"
    system "./test"
  end
end
