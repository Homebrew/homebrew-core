class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  license "GPL-2.0-or-later"
  revision 8
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git", branch: "master"

  stable do
    url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/2.2.2.tar.gz"
    sha256 "8c4c42ab68144a9e2349710d42c0248407a87e7dc0ba4366891905322b331f92"

    # Backport support for FFmpeg 5. Remove in the next release
    patch do
      url "https://github.com/dirkvdb/ffmpegthumbnailer/commit/372cd422e57a9a3531eb9a30559d665caecff1ba.patch?full_index=1"
      sha256 "88aecad1b3ba9d564b365a6fa19bf56d14c43d0185de7aefa2e75901669269b9"
    end
    patch do
      url "https://github.com/dirkvdb/ffmpegthumbnailer/commit/3e63ed4a7f092aa6908a417bb800b25eaf3b1e2d.patch?full_index=1"
      sha256 "629ac4ff56cda4066798233c906ca907cfab6c4e36e1d0fb25ead4d7acb1eaaf"
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "e36e590201269de1fec5a9938c4fa60a0176e7187db91e397384a879881802d0"
    sha256 cellar: :any,                 arm64_monterey: "66cbd49c6b84e8114de030e1eeb7b5a606e9d14f3c65a9b8bcd3ec324cbab0a3"
    sha256 cellar: :any,                 arm64_big_sur:  "2a61ee9136df3089557379131d74dbc8fa441eed0621acf87b4171a38bc6720a"
    sha256 cellar: :any,                 ventura:        "1a435517f1c3f026a741d62742c8bac5252527cd111158dadaf328d1ab80d33f"
    sha256 cellar: :any,                 monterey:       "d61618b8c967b3185b89138c1d738ee9d64b16e543b319c8488c83bdd130e1e4"
    sha256 cellar: :any,                 big_sur:        "bddd1e1385f4bd432a6ed5b9650d60b9f198d09312a1d7eec24120b650a02062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "889af5605b11dfe290b17e588d1636dda2e9137bf4b0e99815cc1d89482bbcb0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DENABLE_GIO=ON",
                    "-DENABLE_TESTS=OFF",
                    "-DENABLE_THUMBNAILER=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    f = Formula["ffmpeg"].opt_bin/"ffmpeg"
    png = test_fixtures("test.png")
    system f.to_s, "-loop", "1", "-i", png.to_s, "-c:v", "libx264", "-t", "30",
                   "-pix_fmt", "yuv420p", "v.mp4"
    assert_predicate testpath/"v.mp4", :exist?, "Failed to generate source video!"
    system "#{bin}/ffmpegthumbnailer", "-i", "v.mp4", "-o", "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?, "Failed to create thumbnail!"
  end
end
