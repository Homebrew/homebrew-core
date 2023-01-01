class Libcpuid < Formula
  desc "Small C library for x86 CPU detection and feature extraction"
  homepage "https://github.com/anrieff/libcpuid"
  url "https://github.com/anrieff/libcpuid/archive/v0.6.2.tar.gz"
  sha256 "3e7f2fc243a6a68d6c909b701cfa0db6422ec33fccf91ea5ab7beda3eb798672"
  license "BSD-2-Clause"
  head "https://github.com/anrieff/libcpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 ventura:      "fb0400133080f37bb561abba69f50809a468ac2e327bca02281de8d4c553f30e"
    sha256 cellar: :any,                 monterey:     "10ee187d9e292dac42be9924bf2b5ea2f495267335e5e5a56a35779d28ff3036"
    sha256 cellar: :any,                 big_sur:      "f7252b191ada11eee6bb25649cba4fda28be44c91ebcfd936e3508d3573bf4f1"
    sha256 cellar: :any,                 catalina:     "e954e21a3bb2ab10c1eb831af1626ccf9cbbe69e123a4da6d69975d59cfca867"
    sha256 cellar: :any,                 mojave:       "9cb4e35df56ce25adcfc4c0a03f1a377aac54ec7e217bc9bb583df41eebcc8c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "20afc15713aa6f9097f50da5ea44d06beda67451c70c52639d9bb973c0f5d26f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on arch: :x86_64

  # Fix build for macOS
  # Remove in the next release
  patch do
    url "https://github.com/anrieff/libcpuid/commit/3b0a1f7e5b10efb978cea4c5cb5b727ba1ef3655.patch?full_index=1"
    sha256 "d4dcc843e78fe5872aba483b0fb5adb0b8e702f6343a383db566dae81eec0d9d"
  end

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"cpuid_tool"
    assert_predicate testpath/"raw.txt", :exist?
    assert_predicate testpath/"report.txt", :exist?
    assert_match "CPUID is present", File.read(testpath/"report.txt")
  end
end
