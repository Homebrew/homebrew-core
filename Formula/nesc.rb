class Nesc < Formula
  desc "Programming language for deeply networked systems"
  homepage "https://github.com/tinyos/nesc"
  url "https://github.com/tinyos/nesc/archive/v1.4.0.tar.gz"
  sha256 "ea9a505d55e122bf413dff404bebfa869a8f0dd76a01a8efc7b4919c375ca000"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "16427c79c0d605ee680a2cef148909ef0323d695344c01e4554327aeffbe3c2b" => :catalina
    sha256 "421acf77b9f7eeb328811365a08b5b870c4386d2eb5ed8f1f0ccf919ac2e0bba" => :mojave
    sha256 "7ceca95835c6b73a0c33a03ff377ac549aac42de7646c6c58350f0e024b8a3b2" => :high_sierra
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
