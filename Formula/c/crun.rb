class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https://github.com/containers/crun"
  url "https://github.com/containers/crun/releases/download/1.27.1/crun-1.27.1.tar.zst"
  sha256 "a1b9829c1de814719df65e2ba3922eb56249c5939a50be769f91e948193cac55"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b19d748311b55bdb382ccf7db91180c726e5c2c6f7d55d9d4bffd9925be490e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1991bfc092bff4c5b41d46304bc157c1ae025ea83a414deec73bd977443f98c6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "go-md2man" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build

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
    assert_empty shell_output("#{bin}/crun --root=#{testpath} list -q").strip
  end
end
