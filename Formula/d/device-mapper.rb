class DeviceMapper < Formula
  desc "Userspace library and tools for logical volume management"
  homepage "https://sourceware.org/dm"
  url "https://sourceware.org/pub/lvm2/releases/LVM2.2.03.41.tgz"
  version "2.03.41"
  sha256 "d58011b845df8ec13816ca13ea6c39d4cb3d038cd2d7d387acdf5681ad7d6637"
  license "LGPL-2.1-only"
  head "https://gitlab.com/lvmteam/lvm2.git", branch: "main"

  livecheck do
    url "https://sourceware.org/pub/lvm2/releases/"
    regex(/href=.*?LVM2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "38297ee55e6173e3d1ffd1de979d3ef2b313b716dab9aa8750592f5fa07e9a7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9ecdab2ca8cbeb7a8a3737fffece10d41f6a0fe5931d4b7580b989b3583cdcfa"
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
