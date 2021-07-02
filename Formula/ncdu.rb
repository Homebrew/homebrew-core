class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-1.16.tar.gz"
  sha256 "2b915752a183fae014b5e5b1f0a135b4b408de7488c716e325217c2513980fd4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "26eb6537a378702dc900546a2069472b51822fe086f380d0793c29adcc71166f"
    sha256 cellar: :any_skip_relocation, big_sur:       "0761e7d2ca14605c0b5d122521c5f9d63f536fd37bb3cf46ae1367b36d4f166f"
    sha256 cellar: :any_skip_relocation, catalina:      "994f7f4e9624a0984ec7c37b5b15b9ae5c24663ebffaba19b0979f4e99919fee"
    sha256 cellar: :any_skip_relocation, mojave:        "f7908eaf47c7842b15e56e17279583f4c938a9c920e1bae41f05d3e5506a99fb"
    sha256 cellar: :any_skip_relocation, high_sierra:   "d094385dbfd71831c5f2b03f0817a06df9471a44f5437aaf577676d2723bc865"
  end

  head do
    url "https://g.blicky.net/ncdu.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncdu -v")
  end
end
