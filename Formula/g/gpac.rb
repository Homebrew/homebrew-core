class Gpac < Formula
  desc "Multimedia framework for research and academic purposes"
  homepage "https://gpac.io/"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/gpac/gpac.git", branch: "master"

  stable do
    url "https://github.com/gpac/gpac/archive/refs/tags/v2.4.0.tar.gz"
    sha256 "99c8c994d5364b963d18eff24af2576b38d38b3460df27d451248982ea16157a"

    # Backport fix for macOS 15+ (Sequoia and later)
    patch do # Fixed in v2.5 but not yet published
      url "https://github.com/gpac/gpac/commit/866784948c02ddfba750999ec212cb206ecc094d.patch?full_index=1"
      sha256 "a7e71a3dcf3daf52faf9f8e9c00e5d9ad2695020f6120f16195c3ffc70598215"
    end

    # Backport fix for detecting xvid correctly
    patch do # Fixed in v2.5 but not yet published
      url "https://github.com/gpac/gpac/commit/a005fd6eb7a9ede4d3356630cae3d6516c91b73e.patch?full_index=1"
      sha256 "dd4ad3079f07378753abf39bf66e615af15d7168cd4bc07d8db2960eaff36fed"
    end

    # Backport fix for the build issues with FFmpeg 7.0+
    patch do # Fixed in v2.5 but not yet published
      url "https://github.com/gpac/gpac/commit/18863aa2176e423dae2a6d7e39ff6ed6a37b2b78.patch?full_index=1"
      sha256 "c4b4e90f6e42ee977d5f0b4f06a0d04fc2925e9bb2695f1119df8d8a839468cb"
    end
    patch :DATA
    patch do
      url "https://github.com/gpac/gpac/commit/1bce910fb2409fdfaa67736c1c5ef6a2e89eddc1.patch?full_index=1"
      sha256 "32785d99d600c7c59031e2867d1ebb7b921dce3aca8917c66270372d35df41e1"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5dd37f08f66d4cd6326954764aff8e02b44a534eb54ac5ebf336152153a1c65c"
    sha256 cellar: :any,                 arm64_sonoma:   "0db848b31b7bda589b829bef38fd0d99575d1303691a04a915d66548b3dac128"
    sha256 cellar: :any,                 arm64_ventura:  "e02c1581892fd72215874516724a24eb30fb7862a1e5d45ebd7cce0b840a3908"
    sha256 cellar: :any,                 arm64_monterey: "b15f699737dc4e58fda9c8753ea2aa2f323baa0423b5424230852bdb0e35b258"
    sha256 cellar: :any,                 sonoma:         "d689fcb607e52f1111fb9ddfb6bf107a40592e16c7f7f536bcbece0b76e69145"
    sha256 cellar: :any,                 ventura:        "be9dbecc82418f0ff125b5838d56ff7e37c7818f64f090df2fc0e35fdec969b4"
    sha256 cellar: :any,                 monterey:       "618101f402082ebc311574e2de377212b20386b346f1f12ab008ded4b647e5fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ccf5c3da135e37dd9e0b42fc2057eec92c01b9d9006229e2132936f0777973cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fa932d0f671a1643b20f381bba3181328431e5ef9555444a8d25a983ace36e1"
  end

  depends_on "pkgconf" => :build
  depends_on "a52dec"
  depends_on "aom"
  depends_on "curl"
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "jack"
  depends_on "jpeg"
  depends_on "jpeg-turbo"
  depends_on "libcaca"
  depends_on "libcaption"
  depends_on "libnghttp2"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxv"
  depends_on "lzip"
  depends_on "mad"
  depends_on "openjpeg"
  depends_on "openssl@3"
  depends_on "pulseaudio"
  depends_on "sdl2"
  depends_on "theora"
  depends_on "xz"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "xvid"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"MP4Box", "-add", test_fixtures("test.mp3"), testpath/"mp4box.mp4"
    assert_path_exists testpath/"mp4box.mp4"

    system bin/"gpac", "-i", test_fixtures("test.mp3"), "-o", testpath/"gpac.mp4"
    assert_path_exists testpath/"gpac.mp4"

    assert_match "ft_font", shell_output("#{bin}/gpac -h modules")
  end
end
__END__
diff --git a/src/filters/ff_common.c b/src/filters/ff_common.c
index 605abd88..f1fa12f1 100644
--- a/src/filters/ff_common.c
+++ b/src/filters/ff_common.c
@@ -922,7 +922,7 @@ GF_FilterArgs ffmpeg_arg_translate(const struct AVOption *opt)
 		break;
 #endif
 	default:
-		GF_LOG(GF_LOG_WARNING, GF_LOG_MEDIA, ("[FFMPEG] Unknown ffmpeg option type %d\n", opt->type));
+		GF_LOG(GF_LOG_WARNING, GF_LOG_MEDIA, ("[FFmpeg] Unknown ffmpeg option type %d\n", opt->type));
 		break;
 	}
 	return arg;
