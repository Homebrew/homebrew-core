class DeviceMapper < Formula
  desc "Userspace library and tools for logical volume management"
  homepage "https://sourceware.org/dm"
  url "https://sourceware.org/git/lvm2.git",
      tag:      "v2_03_24",
      revision: "90ec2cd92f6367c431dd8dae55d0cbe7e196734f"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/href=.*?;a=tag;.*?>Release (\d+(?:\.\d+)+)</i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "03b2479a8e32ed56d4b0308ccd432950321e140960b7bac48525eb7fd97f8a55"
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
