class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https://github.com/containers/crun"
  url "https://github.com/containers/crun/releases/download/1.25.1/crun-1.25.1.tar.zst"
  sha256 "c3afabe57d215ee32517b94600e2d0f40467d07afeb9260afc003394882f7163"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "be07f5866c971c57b254ecb4fb3b71c057167c9e7b0f1662ada44b4fad4bfd2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dea7b7cbc21d602ee2adc99c969ec3faa24d804ada27bca29f3a223c55399cfb"
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
