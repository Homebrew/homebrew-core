class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https://github.com/containers/crun"
  url "https://github.com/containers/crun/releases/download/1.29.1/crun-1.29.1.tar.zst"
  sha256 "0fc095f629b6bba010b0cfa8b25ca1f769455e8891e06eb62c829ddc92ea2cad"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any, arm64_linux:  "4d91b9badf593c9fbe77f2d14b0e30d1612ac97a7b1d3174f9672e939b93d538"
    sha256 cellar: :any, x86_64_linux: "53d354b9b1a01ffb2bf49ed319e156290447e654a2e1b34f69f1b6eea4d456fd"
  end

  head do
    url "https://github.com/containers/crun.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "go-md2man" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build

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
