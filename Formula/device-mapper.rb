class DeviceMapper < Formula
  desc "Userspace library and tools for logical volume management"
  homepage "https://sourceware.org/dm"
  url "https://sourceware.org/git/lvm2.git",
      tag:      "v2_03_19",
      revision: "f7dd2562c53347cec69bc060f838c95839770586"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/href=.*?;a=tag;.*?>Release (\d+(?:\.\d+)+)</i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bd02d0060dc892a5dec248a46f2f74f3f2a4e8da2ee12479d5f7cea06f76c7a1"
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
