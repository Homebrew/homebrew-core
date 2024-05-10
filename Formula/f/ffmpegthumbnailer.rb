class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  license "GPL-2.0-or-later"
  revision 10
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git", branch: "master"

  stable do
    url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/refs/tags/2.2.2.tar.gz"
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
    sha256 cellar: :any,                 arm64_sonoma:   "235ab42ecf1f474a0384e45a2e78fd9f30841e5749af68eefe462b6abefde494"
    sha256 cellar: :any,                 arm64_ventura:  "937e42bc36a29d57502d71354e24b73a5be2da001d99fa1af4343e72c0f1cc69"
    sha256 cellar: :any,                 arm64_monterey: "e848acd7b52d186e84410b372e9fcc736a793bf821146a075a52d632141e197e"
    sha256 cellar: :any,                 sonoma:         "a434eb881dd1ad39b2ec6a9e6cc0b5bc717bda9c93b889e1854dd94b91b3adcb"
    sha256 cellar: :any,                 ventura:        "1c9e947edabc6c624ff242a4a1852096a2199d16595a15df3ecfee9bc6f50893"
    sha256 cellar: :any,                 monterey:       "d44e1ebe5f523a76d2872cc4dc25333743f2297b0fac57aceeffb28b91fe2c12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "335052fa0c62e6e0406baf107c55b02f5ff726d774fdfe6ad30896d0f3ef95cf"
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
