class DeviceMapper < Formula
  desc "Userspace library and tools for logical volume management"
  homepage "https://sourceware.org/dm"
  url "https://sourceware.org/git/lvm2.git",
      tag:      "v2_03_35",
      revision: "38c1124a478fa3889c649338b6e8ccdc0370e201"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/href=.*?;a=tag;.*?>Release (\d+(?:\.\d+)+)</i)
    strategy :page_match
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "29578119ec55b8eae5eeb0408603282220c8222b6c09763305bccf926b088548"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "46e4275b74e88c24650eeab6f7d4ebbdc154477f9e83d9ac781ee2a3b4a59e18"
  end

  depends_on "pkgconf" => :build
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
    (testpath/"test.c").write <<~C
      #include <libdevmapper.h>

      int main() {
        if (DM_STATS_REGIONS_ALL != UINT64_MAX)
          exit(1);
      }
    C
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ldevmapper", "test.c", "-o", "test"
    system testpath/"test"
  end
end
