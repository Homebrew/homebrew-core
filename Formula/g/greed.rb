class Greed < Formula
  desc "Game of consumption"
  homepage "http://www.catb.org/~esr/greed/"
  url "http://www.catb.org/~esr/greed/greed-4.2.tar.gz"
  sha256 "702bc0314ddedb2ba17d4b55d873384a1606886e8d69f35ce67f6e3024a8d3fd"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/greed.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?greed[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36c2fea013a54064053d5ce3e5a72dd7f2acdda4151221c87963b330e6b11766"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e742fb2edc5d957f895a9843bb3432f0b965f582e53bf315ac6a1eec2c3cd78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "197eaf64e266d04b451278067451a05271ee348e04c860c360212f22e0a22cd2"
    sha256 cellar: :any_skip_relocation, ventura:        "4186bd81b2117f752ef4f6ef551a8fbd0394f45bc14945aa95c346e846deeafb"
    sha256 cellar: :any_skip_relocation, monterey:       "f63c247592d7a30dfe5683919c96bc572b4841695358b94627895deb7e48dfa5"
    sha256 cellar: :any_skip_relocation, big_sur:        "15791321c59787d6e5b633efb195e0b7edf8c92976d5c6991e12a920a9f46a00"
    sha256 cellar: :any_skip_relocation, catalina:       "64d0028754d683a8bbe1de0bb1a7319dcf6d8020c6d3624e58df5b5be3bf4e42"
    sha256 cellar: :any_skip_relocation, mojave:         "9cba951e4fd73d29a1e4899a4f2a7d5f0158f6f5b6d02bb75837c7296530e65c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "9685dcc52ad08b19964cfb61f4fd0d9e28ec0d42cde2f112da4e9be1e1d15b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ab888e57c904b28bca019bcbf06b8439d8d0f3594acb3f5306441797af4da55"
  end

  uses_from_macos "ncurses"

  def install
    # Handle hard-coded destination
    inreplace "Makefile", "/usr/share/man/man6", man6
    # Make doesn't make directories
    bin.mkpath
    man6.mkpath
    (var/"greed").mkpath
    # High scores will be stored in var/greed
    system "make", "SFILE=#{var}/greed/greed.hs"
    system "make", "install", "BIN=#{bin}"
  end

  def caveats
    <<~EOS
      High scores will be stored in the following location:
        #{var}/greed/greed.hs
    EOS
  end

  test do
    assert_predicate bin/"greed", :executable?
  end
end
