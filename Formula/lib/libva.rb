class Libva < Formula
  desc "Hardware accelerated video processing library"
  homepage "https://github.com/intel/libva"
  url "https://github.com/intel/libva/releases/download/2.19.0/libva-2.19.0.tar.bz2"
  sha256 "963be798d559df7feebda6fa81aa0dae6f9409c633a37909c44c6aa8af1e2174"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "644cb7da12a2db6f51ebd9fb36e6ba134b5ffa963367e8abe7e5743dd24522a2"
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
