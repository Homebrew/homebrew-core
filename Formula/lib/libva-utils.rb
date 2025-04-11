class LibvaUtils < Formula
  desc "Collection of tests for VA-API"
  homepage "https://github.com/intel/libva-utils"
  url "https://github.com/intel/libva-utils/releases/download/2.22.0/libva-utils-2.22.0.tar.bz2"
  sha256 "6d64f0d44ef455442a22633331bf81d5eef722fea564942dfda32fb89f7adc45"
  license all_of: ["MIT", "BSD-3-Clause"]

  depends_on "pkgconf" => :build
  depends_on "mesa" => :test
  depends_on "xorg-server" => :test

  depends_on "libdrm"
  depends_on "libva"
  depends_on "libx11"
  depends_on :linux
  depends_on "wayland"

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-drm",
                          "--enable-wayland",
                          "--enable-x11",
                          *std_configure_args
    system "make", "install"
  end

  test do
    xvfb_pid = spawn Formula["xorg-server"].bin/"Xvfb", ":1"
    ENV["DISPLAY"] = ":1"
    ENV["XDG_RUNTIME_DIR"] = testpath
    sleep 5
    assert_match "Driver version: Mesa Gallium driver", shell_output("#{bin}/vainfo")
  ensure
    Process.kill "TERM", xvfb_pid
  end
end
