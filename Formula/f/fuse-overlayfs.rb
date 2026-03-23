class FuseOverlayfs < Formula
  desc "FUSE implementation for overlayfs"
  homepage "https://github.com/containers/fuse-overlayfs"
  url "https://github.com/containers/fuse-overlayfs/archive/refs/tags/v1.16.tar.gz"
  sha256 "45968517603389ead067222d234bc8d8ed33e4b4f8ba16216bdd3e6aedcccea9"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "7649727cba94e4394ec42a29c8dbb1c9bad932f1125b0ad27f8e3b65e014d5fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b6506681f06a7d624118e4570f465e79cccf1ee7374b3a2d7e088adf46e72252"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "libfuse"
  depends_on :linux

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    mkdir "lowerdir/a"
    mkdir "lowerdir/b"
    mkdir "up"
    mkdir "workdir"
    mkdir "merged"
    test_cmd = "fuse-overlayfs -o lowerdir=lowerdir/a:lowerdir/b,upperdir=up,workdir=workdir merged 2>&1"
    output = shell_output(test_cmd, 1)
    assert_match "fuse: device /dev/fuse not found. Kernel module not loaded?", output
    assert_match "fuse-overlayfs: cannot mount: No such file or directory", output
  end
end
