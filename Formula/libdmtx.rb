class Libdmtx < Formula
  desc "Data Matrix library"
  homepage "https://libdmtx.sourceforge.io"
  url "https://github.com/dmtx/libdmtx/archive/v0.7.7.tar.gz"
  sha256 "7aa62adcefdd6e24bdabeb82b3ce41a8d35f4a0c95ab0c4438206aecafd6e1a1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8b618efa0c3059ac26262d016e74fdd1d8e2e9507fba28a614fae2435011eddf"
    sha256 cellar: :any,                 arm64_monterey: "561f25578f3a60d6d122900a35d3a8e55745f74caeead32bbaa91f9cd0681a65"
    sha256 cellar: :any,                 arm64_big_sur:  "af07cb3d3398112398d1a0a50bb05569490506f7e679a5e31a31949f7b3e694e"
    sha256 cellar: :any,                 ventura:        "73bc2b78b88622b27ad5ac1283ce98d8a3288739dac1df45acea255e013e280b"
    sha256 cellar: :any,                 monterey:       "3728775d7a7d51ca7d837e9dc031e3e0fea98c46afac79955a49e631c82661f8"
    sha256 cellar: :any,                 big_sur:        "139365f0bea5191d4cd5d7d66ad82dccb5298f7d96601e7c67ba26b6d12fe42b"
    sha256 cellar: :any,                 catalina:       "eabd4735b2e09deeb7746eec9205c47c6600d95fb196118f497d55461342c1f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09b0cd47edf7d77d1ab0ba619ee03e0b41c6896ef37ec6d0841e0bedf286f988"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
