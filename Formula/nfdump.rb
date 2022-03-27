class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://github.com/phaag/nfdump/archive/v1.6.24.tar.gz"
  sha256 "11ea7ecba405d57076c321f6f77491f1c64538062630131c98ac62dc4870545e"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "39c67075d143f58892baadff95c631182c4d80183b2ab38cdeb0df475c192bd7"
    sha256 cellar: :any, arm64_big_sur:  "0166cf87b2fac3b3d48f54a7b5d3dd2433e43fd0aa21500f485167e035b09d49"
    sha256 cellar: :any, monterey:       "157477b2e290a049a25c4d12001fb0492e8c8342612f22ccb9169493686b58d1"
    sha256 cellar: :any, big_sur:        "04cb78152af1e986c69f60f6e3437cce46d362f4087ded5717e6ab0390cc7041"
    sha256 cellar: :any, catalina:       "cd1575d5edc5474ab44e8729ef1fbdb10df0508b96d408888ab147d7ba6408f5"
    sha256 cellar: :any, mojave:         "cf8ab09a45c609ba6deb8e4b7db49077c301c228658b778ecd29f81b9fbb1482"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libpcap"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--enable-readpcap"
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end
