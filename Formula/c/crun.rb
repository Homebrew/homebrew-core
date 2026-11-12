class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https://github.com/containers/crun"
  url "https://github.com/containers/crun/releases/download/1.31/crun-1.31.tar.zst"
  sha256 "cb76a7951438205466725307e4061da6d1dfdc202bdf675cf209c7037b94002b"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_linux:  "f8a9d708662d31dfb3e0ff95110cd47cb19dbb31972e4d00dcf6d99b496ad5bf"
    sha256 cellar: :any, x86_64_linux: "757087841988beb70fe3be6f5a6315e45be8c66fc8cb488f5677b2acb7632f76"
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
