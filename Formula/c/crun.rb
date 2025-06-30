class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https://github.com/containers/crun"
  url "https://github.com/containers/crun/releases/download/1.22/crun-1.22.tar.zst"
  sha256 "f1d2035e4f2a41d68f5c5b786ebbc4f94385f2e037df2ca0898f2449a810bfc6"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "48e6dfa33d60b46d20b19ee5a93df7ca7b6b4f327f3cf022fe7986c9650d0d72"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7cb1901a9b6a7cbd680882e65ef2965a4d4f2e736441a563258e57ff9ea63519"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "go-md2man" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build

  depends_on "libcap"
  depends_on "libseccomp"
  depends_on :linux
  depends_on "systemd"
  depends_on "yajl"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_empty shell_output("#{bin}/crun --rootless=true list -q").strip
  end
end
