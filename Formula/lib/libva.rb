class Libva < Formula
  desc "Hardware accelerated video processing library"
  homepage "https://github.com/intel/libva"
  url "https://github.com/intel/libva/releases/download/2.24.1/libva-2.24.1.tar.bz2"
  sha256 "eec6050b52876f229bd35e9df17cd31a06785e18e6f7990c445b584628483d67"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "bc69c23e17cd2f068efdc36c190455c64069e0f7545607bda0a7eb1e2c25ae69"
    sha256 cellar: :any, x86_64_linux: "2092e481da1a3e32d3bde715914bf2e1049b2698351e9bd45d50c98db3ee07e4"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "libdrm"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on :linux
  depends_on "wayland"

  def install
    system "./configure", "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-silent-rules",
                          "--enable-drm",
                          "--enable-x11",
                          "--disable-glx",
                          "--enable-wayland",
                          "--with-drivers-path=#{HOMEBREW_PREFIX}/lib/dri",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    %w[libva libva-drm libva-wayland libva-x11].each do |name|
      assert_match "-I#{include}", shell_output("pkgconf --cflags #{name}")
    end

    # We cannot run a functional test without a VA-API driver; however, the
    # drivers have a dependency on `libva` which results in a dependency loop
    (testpath/"test.c").write <<~C
      #include <stddef.h>
      #include <va/va.h>
      int main(int argc, char *argv[]) {
        VADisplay display = NULL;
        vaDisplayIsValid(display);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lva"
    system "./test"
  end
end
