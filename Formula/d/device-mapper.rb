class DeviceMapper < Formula
  desc "Userspace library and tools for logical volume management"
  homepage "https://sourceware.org/dm"
  url "https://sourceware.org/git/lvm2.git",
      tag:      "v2_03_27",
      revision: "207990a8770208151b2f39b51526580a9dca24c4"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/href=.*?;a=tag;.*?>Release (\d+(?:\.\d+)+)</i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "39097c07a211130a84a4f7c110359a983b796a2e201af457c3a9d2d73896d300"
  end

  depends_on "pkg-config" => :build
  depends_on "libaio"
  depends_on :linux

  def install
    # https://github.com/NixOS/nixpkgs/pull/52597
    ENV.deparallelize
    system "./configure", "--disable-silent-rules", "--enable-pkgconfig", *std_configure_args
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
