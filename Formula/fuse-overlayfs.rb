class FuseOverlayfs < Formula
  desc "FUSE implementation for overlayfs"
  homepage "https://github.com/containers/fuse-overlayfs"
  url "https://github.com/containers/fuse-overlayfs/archive/refs/tags/v1.11.tar.gz"
  sha256 "320a411425414679736dcb7f3b05146430ca4af20ded0096c69ac3c7540ebca2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "abbc5127c91f4ddd02a48858f43581f2aab41ff4fb2318f90c0d8f9882c9e964"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  depends_on "libfuse"
  depends_on :linux

  def install
    system "autoreconf", "-fis"
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
    assert_match "fuse: device not found, try 'modprobe fuse' first", output
    assert_match "fuse-overlayfs: cannot mount: No such file or directory", output
  end
end
