class Libvorbis < Formula
  desc "Vorbis general audio compression codec"
  homepage "https://xiph.org/vorbis/"
  url "https://ftp.osuosl.org/pub/xiph/releases/vorbis/libvorbis-1.3.7.tar.xz"
  mirror "https://github.com/xiph/vorbis/releases/download/v1.3.7/libvorbis-1.3.7.tar.xz"
  sha256 "b33cc4934322bcbf6efcbacf49e3ca01aadbea4114ec9589d1b1e9d20f72954b"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/vorbis/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)libvorbis[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "99c0de7ff87f4648bb17acd0324a15563e975b7492dbd4f11fd656a8eb6b5622"
    sha256 cellar: :any,                 arm64_sequoia:  "c28d1e0b461a4cf6f5aee72e664ac6f5f6f3efaab44f15b91924f08474cfafe1"
    sha256 cellar: :any,                 arm64_sonoma:   "f71115c28f65e1a87ae0dbe695421ecacfcddcaa6f91a3e0a23493da73560de5"
    sha256 cellar: :any,                 arm64_ventura:  "941871c7cfee1e15b60191e1c70296554871bc36e4fc8104ffc8919bb767f555"
    sha256 cellar: :any,                 arm64_monterey: "08fc2566eda5d6fc2204c822bac51383a59c4536bae539b77cfe8c7f247f7517"
    sha256 cellar: :any,                 arm64_big_sur:  "37bcbe572118f7cc87daa488ef3d67c5cbd38e9e12e2e2b408df286f9b2fdc37"
    sha256 cellar: :any,                 sonoma:         "94aafb164cf8490d1d7c1cbe32695995c592c63a8cafe8621e793819079d7f46"
    sha256 cellar: :any,                 ventura:        "4e1a3b6ba6e8f790974930a7ceda16a3fb0b50d544021f6e39d1b38392e98512"
    sha256 cellar: :any,                 monterey:       "bd3125f7734f888f4ae9065f0b41a2baa281064686068f6c4189044d2408d0a8"
    sha256 cellar: :any,                 big_sur:        "6401378d08490ed76f4894b7e0812ef5cfbade699331dc07b7e88ad5438f7a78"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f3dac34ab6697f236712689aede48c8519f66cb6f3c69d6fb98169ed546ba198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41daf79ce53910061acbe1f63ca95f53b4149d3ebb2b97c2bb4d31845820f219"
  end

  head do
    url "https://gitlab.xiph.org/xiph/vorbis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libogg"

  resource("oggfile") do
    url "https://upload.wikimedia.org/wikipedia/commons/c/c8/Example.ogg"
    sha256 "f57b56d8aae4c847cf01224fb45293610d801cfdac43d932b5eeab1cd318182a"
  end

  def install
    system "./autogen.sh" if build.head?
    inreplace "configure", " -force_cpusubtype_ALL", ""
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <assert.h>
      #include "vorbis/vorbisfile.h"
      int main (void) {
        OggVorbis_File vf;
        assert (ov_open_callbacks (stdin, &vf, NULL, 0, OV_CALLBACKS_NOCLOSE) >= 0);
        vorbis_info *vi = ov_info (&vf, -1);
        printf("Bitstream is %d channel, %ldHz\\n", vi->channels, vi->rate);
        printf("Encoded by: %s\\n", ov_comment(&vf,-1)->vendor);
        return 0;
      }
    C
    testpath.install resource("oggfile")
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lvorbisfile",
                   "-o", "test"
    assert_match "2 channel, 44100Hz\nEncoded by: Lavf59.27.100",
                 shell_output("./test < Example.ogg")
  end
end
