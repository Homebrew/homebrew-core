class Ntfs2btrfs < Formula
  desc "In-place conversion of NTFS filesystem to Btrfs"
  homepage "https://github.com/maharmstone/ntfs2btrfs"
  url "https://github.com/maharmstone/ntfs2btrfs/archive/refs/tags/20260810.tar.gz"
  sha256 "be3d2deb3c042c862df3ca75b46245300f45e279206bddabd8aa1fc8c92c1a58"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_linux:  "c139abbe7d8f44eb06653558601dca6a230baf8cd8c96a17035c13f4642db4b7"
    sha256 cellar: :any, x86_64_linux: "8605d243309e7ec4ce118bfa19a1af25ec552eb73509a975a711cb6f074ee0bd"
  end

  depends_on "cmake" => :build
  # C++23 named modules are only supported by the Ninja generator
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "btrfs-progs" => :test
  depends_on "file-formula" => :test
  depends_on "ntfs-3g" => :test
  depends_on "gcc"
  depends_on :linux
  depends_on "lzo"
  depends_on "zlib-ng-compat"
  depends_on "zstd"

  fails_with :gcc do
    version "14"
    cause "Requires GCC 15 for C++23 named module support"
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-GNinja",
                    "-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON",
                    "-DCMAKE_INSTALL_SBINDIR=#{bin}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "truncate", "-s", "1G", "testdisk"
    system "mkfs.ntfs", "-f", "-F", "testdisk"
    assert_match(/NTFS partition \w+ was processed successfully/, shell_output("ntfsfix -n testdisk"))
    assert_match %r{Calculating checksums (\d+) / \1}, shell_output("#{bin}/ntfs2btrfs testdisk")
    assert_match(/found [1-9]\d* bytes used, no error found/, shell_output("btrfs check testdisk"))
  end
end
