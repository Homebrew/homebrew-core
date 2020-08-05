class Nesc < Formula
  desc "Programming language for deeply networked systems"
  homepage "https://github.com/tinyos/nesc"
  url "https://github.com/tinyos/nesc/archive/v1.4.0.tar.gz"
  sha256 "ea9a505d55e122bf413dff404bebfa869a8f0dd76a01a8efc7b4919c375ca000"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "b2ce356c9fb1177a17e2e2b82cc7e91f9126ecc68435ba0cea0ea94f65def27c" => :catalina
    sha256 "9b261a0f665954574e417d0f7509d2253d09ab45f43e6db48ddaa4e81120e8ba" => :mojave
    sha256 "bb30d87ef9a3896e8dc9fa346854ecad17d2ac42ebdb3d5d800a548b839afc37" => :high_sierra
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
