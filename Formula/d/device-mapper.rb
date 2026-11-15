class DeviceMapper < Formula
  desc "Userspace library and tools for logical volume management"
  homepage "https://sourceware.org/dm"
  url "https://sourceware.org/pub/lvm2/releases/LVM2.2.03.44.tgz"
  version "2.03.44"
  sha256 "42f829927d2d459f5733fcdb38a5bf2455a8b84072193092450a9c69d6596eca"
  license "LGPL-2.1-only"
  compatibility_version 1
  head "https://gitlab.com/lvmteam/lvm2.git", branch: "main"

  livecheck do
    url "https://sourceware.org/pub/lvm2/releases/"
    regex(/href=.*?LVM2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "43d427ddbb0f61c455d415a79415705d850489807d241e163b2528d0d251bc43"
    sha256 cellar: :any, x86_64_linux: "eba39145ebad82fc636e6f765b5bf62b9bf6b81595d9a7a3857ed4e4c95cd318"
  end

  depends_on "pkgconf" => :build
  depends_on "libaio"
  depends_on :linux

  deny_network_access!

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
