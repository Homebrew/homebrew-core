class DeviceMapper < Formula
  desc "Userspace library and tools for logical volume management"
  homepage "https://sourceware.org/dm"
  url "https://sourceware.org/git/lvm2.git",
      tag:      "v2_03_36",
      revision: "c8b7a765cbd731af32964adaf921f9e19d56a048"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/href=.*?;a=tag;.*?>Release (\d+(?:\.\d+)+)</i)
    strategy :page_match
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "6187c3179c34e7c6f48fb25d0f6f8790a5d2e804e70ccdc5d86f5991b44f7d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4341ac03f60eed61eaa6dd1e3274ac8a22e3e524aab2c4a225eedb68905d1cda"
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
