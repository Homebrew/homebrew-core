class Nesc < Formula
  desc "Programming language for deeply networked systems"
  homepage "https://github.com/tinyos/nesc"
  url "https://github.com/tinyos/nesc/archive/v1.4.0.tar.gz"
  sha256 "ea9a505d55e122bf413dff404bebfa869a8f0dd76a01a8efc7b4919c375ca000"
  license "GPL-2.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a5476ebb9ff86e8aa35abe101f26893f3be3dc6cd709fd30d0012c778699a20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77716c3fa900dafb63734a8b40178b0fd8d263f1aa047869d6bf31d3941d03f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4d4450e60720f1c811afbf0a423de2809587d0a61bfdf73b2bd9b78054070cc"
    sha256 cellar: :any_skip_relocation, ventura:        "4608c4e67325022c55a0f991afcad53aa00355a559b33dcfe6bdf61d0a883aed"
    sha256 cellar: :any_skip_relocation, monterey:       "77f2ceb7722575686a928f300064a5df68d46d89f97648662a90321e2aec179a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f1a0aa5ac89e1c7b0f278aaab584ce98dd4ae31a94fd9bb111287e8fcba8131"
    sha256 cellar: :any_skip_relocation, catalina:       "b2ce356c9fb1177a17e2e2b82cc7e91f9126ecc68435ba0cea0ea94f65def27c"
    sha256 cellar: :any_skip_relocation, mojave:         "9b261a0f665954574e417d0f7509d2253d09ab45f43e6db48ddaa4e81120e8ba"
    sha256 cellar: :any_skip_relocation, high_sierra:    "bb30d87ef9a3896e8dc9fa346854ecad17d2ac42ebdb3d5d800a548b839afc37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09def7e758ed0e91c1557f6ee6994815db45bb14c9f3f3bcba5848f6e1fa2bf3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openjdk" => :build
  depends_on "emacs"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

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
