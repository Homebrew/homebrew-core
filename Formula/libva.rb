class Libva < Formula
  desc "Hardware accelerated video processing library"
  homepage "https://github.com/intel/libva"
  url "https://github.com/intel/libva/releases/download/2.10.0/libva-2.10.0.tar.bz2"
  sha256 "fa81e35b50d9818fce5ec9eeeeff08a24a8864ceeb9a5c8e7ae4446eacfc0236"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "libdrm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on :linux
  depends_on "wayland"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-drm",
                          "--enable-x11",
                          "--disable-glx",
                          "--enable-wayland"
    system "make"
    system "make", "install"
  end

  test do
    %w[libva libva-drm libva-wayland libva-x11].each do |name|
      assert_match "-I#{include}", shell_output("pkg-config --cflags #{name}")
    end
    (testpath/"test.c").write <<~EOS
      #include <va/va.h>
      int main(int argc, char *argv[]) {
        VADisplay display;
        vaDisplayIsValid(display);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lva"
    system "./test"
  end
end
