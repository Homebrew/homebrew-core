class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https://github.com/containers/crun"
  url "https://github.com/containers/crun/releases/download/1.26/crun-1.26.tar.zst"
  sha256 "8218cf0f59c6cf2931b4ba8d19dbab1efc1557cbb94662903d17d6787442244d"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a03436c1ef83176ab51ccad70d071768d732587f9e458b1f95074a3ada9cd495"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "45b964c428f2f3b53da28086c0113b227651cef23a0f5c1fe6595a0ef883bc1a"
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
