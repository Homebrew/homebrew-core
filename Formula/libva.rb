class Libva < Formula
  desc "Hardware accelerated video processing library"
  homepage "https://github.com/intel/libva"
  url "https://github.com/intel/libva/releases/download/2.11.0/libva-2.11.0.tar.bz2"
  sha256 "6e361117038b571ad4741d38c9280db8c140b17e76e8c01fc7a4d608d3ed7d5d"
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
