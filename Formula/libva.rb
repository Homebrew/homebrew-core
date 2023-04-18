class Libva < Formula
  desc "Hardware accelerated video processing library"
  homepage "https://github.com/intel/libva"
  url "https://github.com/intel/libva/releases/download/2.18.0/libva-2.18.0.tar.bz2"
  sha256 "a3577eeba0c23924686c7e2f2030073736c8282a80f27b5473e33ea94ccd4982"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e87f11aa28f3b1ea8120a8377218989228bcb50c1bb2b158271eeedbb228ae80"
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
