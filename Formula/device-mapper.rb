class DeviceMapper < Formula
  desc "Userspace library and tools for logical volume management"
  homepage "https://sourceware.org/dm"
  url "https://sourceware.org/git/lvm2.git",
      tag:      "v2_03_15",
      revision: "6987f318ec135ffd54a05872a8aa621726fe7acb"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    strategy :page_match
    regex(/href=.*?;a=tag;.*?>Release (\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "97dae8f1149a52afaa5d3caba930b3bc8bf2e0bca1234f83685d06e8bb4bf005"
  end

  depends_on "libaio"
  depends_on :linux

  def install
    # https://github.com/NixOS/nixpkgs/pull/52597
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-pkgconfig"
    system "make", "device-mapper"
    system "make", "install_device-mapper"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libdevmapper.h>

      int main() {
        if (DM_STATS_REGIONS_ALL != UINT64_MAX)
          exit(1);
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ldevmapper", "test.c", "-o", "test"
    system testpath/"test"
  end
end
