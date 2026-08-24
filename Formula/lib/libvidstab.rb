class Libvidstab < Formula
  desc "Transcode video stabilization plugin"
  homepage "https://github.com/georgmartius/vid.stab"
  url "https://github.com/georgmartius/vid.stab/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "96db34d48a9e3aa13736a48744b56dfb76731ac9bb5193c716de8534c9fd709d"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e6808d2f543809c806b81c690719b23c14c177cbb0cb1f42c27d559b4cb1b172"
    sha256 cellar: :any, arm64_sequoia: "1499410c829a5312dd38682273c2778295491d91432d4b7eb6cb6e52250c35f4"
    sha256 cellar: :any, arm64_sonoma:  "2710a74f31a3b2cfa1e5db6ceacbbc671c4d3cbf1aba56f135e77be10b0c6f19"
    sha256 cellar: :any, sonoma:        "347ebfc7f8708d4180ca0451befc27c9d7d3253c300743798eeeeb28e0af8348"
    sha256 cellar: :any, arm64_linux:   "5e7a3fa37aa34043a2e47f20866fb350f83b8be9b33832e8fd680edc554e9ac6"
    sha256 cellar: :any, x86_64_linux:  "f49c718bd54a5616ffd54f43e1da65a74c0795fc16ad0fdb6aaa9168f0e10938"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  def install
    args = %w[
      -DUSE_OMP=OFF
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <vid.stab/libvidstab.h>
      #include <stdio.h>
      int main() {
        printf("libvidstab version: %s\\n", LIBVIDSTAB_VERSION);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs vidstab").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
