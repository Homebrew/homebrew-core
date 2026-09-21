class NativefiledialogExtended < Formula
  desc "Native file dialog library with C and C++ bindings"
  homepage "https://github.com/btzy/nativefiledialog-extended"
  url "https://github.com/btzy/nativefiledialog-extended/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "38116050495cd7de77a91d6d8d59c1aa0a0848c56daa60029bd5b59f3c897229"
  license "Zlib"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "482ed246590013b5718983202acd16cc9894e3c53ce89649bb12bbb802e01642"
    sha256 cellar: :any, arm64_tahoe:       "bad96e7ef75a6fe5a4e87b8d249bbf08e263c429e12af85f015d19ea196d3c35"
    sha256 cellar: :any, arm64_sequoia:     "0c186de91e0d1dc30015f61e24f980bf1dbb2b27e92feff01d1f3866551fc8d7"
    sha256 cellar: :any, arm64_linux:       "f37df06a7df46f4038379fa40db27e3bae879df197857ce50a8d12a4902643a2"
    sha256 cellar: :any, x86_64_linux:      "3acaf44171f45b086223cc2cf6c3e203a11133ded73ba10b54dd69be3938621c"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "wayland-protocols" => :build
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "wayland"
  end

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
