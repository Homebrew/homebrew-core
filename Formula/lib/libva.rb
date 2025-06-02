class Libva < Formula
  desc "Hardware accelerated video processing library"
  homepage "https://github.com/intel/libva"
  url "https://github.com/intel/libva/releases/download/2.22.0/libva-2.22.0.tar.bz2"
  sha256 "e3da2250654c8d52b3f59f8cb3f3d8e7fb1a2ee64378dbc400fbc5663de7edb8"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "fdff2870c6a9e5dae9d2f34703a55112bbc86ffd0ff8426d7e52b3a3fbae9720"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "159b556ea708ad404ef2716f18c3e135e285b3f55be0ca01905fc4205b48cc24"
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
