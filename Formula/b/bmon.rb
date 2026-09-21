class Bmon < Formula
  desc "Interface bandwidth monitor"
  homepage "https://github.com/tgraf/bmon"
  url "https://github.com/Jafaral/bmon/archive/refs/tags/v5.0.tar.gz"
  sha256 "cd7f5fb366a8c32c0e33c79a5daae78edd273993d0edf1036638f269400cf012"
  license "BSD-2-Clause"
  head "https://github.com/tgraf/bmon.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a684507da86e052a46b11a4c7815415f754608abb5395cc467f31c8bca2bd24d"
    sha256 cellar: :any, arm64_tahoe:       "1cf3adad3a4bdbc8b071e51ef8efd5dde4a6ef48058bc3025ad601839f4977bc"
    sha256 cellar: :any, arm64_sequoia:     "c5859ba57d8671ed23d9e371a0de6c33898b8c4c617f54825700cae8042c7da5"
    sha256 cellar: :any, arm64_linux:       "e0b494ae4fe8cd5b72eedc13ec08066a5e9258683a41f504c92d919e96aeb377"
    sha256 cellar: :any, x86_64_linux:      "2baa9b8b5c26ac014eb6e5473bd1dd4d7eebcf29faf5a2f4c6130d13cdccaca4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "confuse"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libnl"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"bmon", "-o", "ascii:quitafter=1"
  end
end
