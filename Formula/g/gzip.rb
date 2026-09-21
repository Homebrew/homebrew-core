class Gzip < Formula
  desc "Popular GNU data compression program"
  homepage "https://www.gnu.org/software/gzip/"
  url "https://ftpmirror.gnu.org/gzip/gzip-1.15.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gzip/gzip-1.15.tar.gz"
  sha256 "545886cf57fa88a65e967fbf705903d7fcb2567c82c7342493e82e8d7b1a210b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a4fc6cf11086f1848bd0bc4d9797cafbaa79cf2ab4098bde4aa034837af517d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2b422221e96dd43b7c7778439f6437073ab1181a6a48796d3b17e1c5ce4cc8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "91a7889ad537212365620a25f0596c9b4928ad517e7c37d1282deb32a63c0977"
    sha256 cellar: :any,                 arm64_linux:       "859bc0e90ca8df3432d76dc17db91fb2ff824a46711ba5a9f96b9c940c16a36e"
    sha256 cellar: :any,                 x86_64_linux:      "c67934ce7882e720c8deb757203f528e9546c0f90451ae35b93a1e0bf7f8a8eb"
  end

  # Fix compile error on aarch64 Linux
  # gzip.h:120:21: error: expected ')' before '+' token
  patch do
    url "https://raw.githubusercontent.com/OpenMandrivaAssociation/gzip/5a3c8e5316bac3ac837f7aa8dc7e3a4b0ba74321/gzip-1.15-aarch64-head-macro.patch"
    sha256 "82ef5b24041eeb86511ce67cb4e60edf8fbfcce01f7a1ab28fd1e024a3050df0"
    type :unofficial
    resolves "https://lists.gnu.org/archive/html/bug-gzip/2026-09/msg00031.html"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write "test"
    system bin/"gzip", "foo"
    system bin/"gzip", "-t", "foo.gz"
    assert_equal "test", shell_output("#{bin}/gunzip -c foo")
  end
end
