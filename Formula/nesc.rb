class Nesc < Formula
  desc "Programming language for deeply networked systems"
  homepage "https://github.com/tinyos/nesc"
  url "https://github.com/tinyos/nesc/archive/v1.4.0.tar.gz"
  sha256 "ea9a505d55e122bf413dff404bebfa869a8f0dd76a01a8efc7b4919c375ca000"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4343650dbcaf2e7d0cf5e886054a5d61cb9660b72f8e79f24a04b15b53a75c4a" => :mojave
    sha256 "9dd650a7f3697a4e59216e992b4d9cac4d2bb3254d8d6f547774fcf895f7e3ee" => :high_sierra
    sha256 "18e2b390839870bda5cae2840be9228e4792ba7f4784a9bb7d7d2573dd228f2c" => :sierra
    sha256 "9bb55ca81ee1ecbed59220ced5045e25b2641dbf24c330f85bfa4c21dbe483fa" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openjdk" => :build
  depends_on "emacs" if MacOS.version >= :catalina

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    # nesc is unable to build in parallel because multiple emacs instances
    # lead to locking on the same file
    ENV.deparallelize

    system "./Bootstrap"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
