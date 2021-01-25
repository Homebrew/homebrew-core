class E2tools < Formula
  desc "Utilities to read, write, and manipulate files in ext2/3/4 filesystems"
  homepage "https://e2tools.github.io/"
  url "https://github.com/e2tools/e2tools/releases/download/v0.1.0/e2tools-0.1.0.tar.gz"
  sha256 "c1a06b5ae2cbddb6f04d070e889b8bebf87015b8585889999452ce9846122edf"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "38978d9bea279b06c646bc82631d59edee4a519164f4b0a4f39b33621ae1183b" => :big_sur
    sha256 "e4c94d559938d504bc7ddc19139c8af004385b57db58bfd24946c451b4752928" => :arm64_big_sur
    sha256 "93eab5f2d207ac8f27a9b27db13408b4b7f8a3cfee4ecbca9d9977a851a41576" => :catalina
    sha256 "1ad81d83b87fc67a54698e6af829dd0945119a41a445383268f1d0190ff7b38d" => :mojave
    sha256 "069988a622ce0587927a4a50b70b778b461840d2db2e49259e1123123bf6a2ff" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "e2fsprogs"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system Formula["e2fsprogs"].opt_sbin/"mkfs.ext2", "test.raw", "1024"
    assert_match "lost+found", shell_output("#{bin}/e2ls test.raw")
  end
end
