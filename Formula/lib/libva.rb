class Libva < Formula
  desc "Hardware accelerated video processing library"
  homepage "https://github.com/intel/libva"
  url "https://github.com/intel/libva/releases/download/2.23.0/libva-2.23.0.tar.bz2"
  sha256 "9ac190a87017bfd49743248f5df7cf3b18a99a9962175caf6bbe3f1ea41b6dbb"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "3c827c66f7377b89450f494ead843b57bcdee01d5ea65e84b7ba152f0090b558"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8704b8b1f7a6086d6d7393aa9ecbc6a497d0b9cd362a8cfa342dfe41a3afb8fe"
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
