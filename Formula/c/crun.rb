class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https://github.com/containers/crun"
  url "https://github.com/containers/crun/releases/download/1.24/crun-1.24.tar.zst"
  sha256 "2cc1ceaa609bc4c25c8e316d30e35406d6588aaf9dafcd5294b6cac912499faf"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "3f9504dcf24e5bb7cd2a86880319d61b15db169bf043cac3fff62333a9430c4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "08a155f155816f7597290a986dbb5b57557ab852a894cc370736101fcfdba068"
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
    assert_empty shell_output("#{bin}/crun --root=#{testpath} list -q").strip
  end
end
