class NativefiledialogExtended < Formula
  desc "Native file dialog library with C and C++ bindings"
  homepage "https://github.com/btzy/nativefiledialog-extended"
  url "https://github.com/btzy/nativefiledialog-extended/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "4a01eafa921169f009f3e83bea8e287d9e5d0b94ca9064cf7f0a546652d7c884"
  license "Zlib"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d368ee5c6aee72210d1852bf1eb11104ef0d90d769a04a1870ad08fd95a97c17"
    sha256 cellar: :any, arm64_tahoe:       "a9edd26f4d75837a4f6131d0c939f053807c85889ba11f03b996b968c2f7b5bc"
    sha256 cellar: :any, arm64_sequoia:     "20da32af5dccba65607c4843b948b3229fcfdd1b780ca78b7480fb848c321ea2"
    sha256 cellar: :any, arm64_linux:       "579a141cd500780b4458c3f83433f9f6197755a59f4d061e12aa6f2addc39439"
    sha256 cellar: :any, x86_64_linux:      "90957ce82bb45b2ff30b190423c2d41772f8e5df789fa8391186421cf5b1cca5"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "wayland-protocols" => :build
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "wayland"
  end

  deny_network_access!

  def install
    if OS.linux?
      # Use our `wayland-protocols` as the tarball lacks the `3ps/wayland-protocols` submodule
      rmdir "3ps/wayland-protocols"
      ln_s Formula["wayland-protocols"].opt_pkgshare, "3ps/wayland-protocols"
    end

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DNFD_BUILD_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <nfd.h>
      #include <stdio.h>
      #include <stdlib.h>

      int main(void) {
        NFD_Init();

        nfdu8char_t *outPath;
        nfdu8filteritem_t filters[2] = { { "Source code", "c,cpp,cc" }, { "Headers", "h,hpp" } };
        nfdopendialogu8args_t args = {0};
        args.filterList = filters;
        args.filterCount = 2;

        NFD_Quit();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lnfd"
    system "./test"
  end
end
