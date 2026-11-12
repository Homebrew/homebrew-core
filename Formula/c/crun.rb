class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https://github.com/containers/crun"
  url "https://github.com/containers/crun/releases/download/1.31/crun-1.31.tar.zst"
  sha256 "cb76a7951438205466725307e4061da6d1dfdc202bdf675cf209c7037b94002b"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_linux:  "da0321c50b3b008dd1a51e43502ad845703059e31cddbe88ae9b0c1261ab843c"
    sha256 cellar: :any, x86_64_linux: "f77798bd644bac0e43ff1a10369f04ca924d9af7c5b682572b006f6441954081"
  end

  head do
    url "https://github.com/containers/crun.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "go-md2man" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15" => :build

  depends_on "json-c"
  depends_on "libcap"
  depends_on "libseccomp"
  depends_on :linux
  depends_on "systemd"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_empty shell_output("#{bin}/crun --root=#{testpath} list -q").strip
  end
end
