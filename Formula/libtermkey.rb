class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.19.tar.gz"
  sha256 "c505aa4cb48c8fa59c526265576b97a19e6ebe7b7da20f4ecaae898b727b48b7"

  bottle do
    cellar :any
    sha256 "e67485b331eeac167fcad54f504952fc1bcfb8a52aa22e6fd139839bb7d6585e" => :sierra
    sha256 "366ea267ec414f63966f3443b21f7479d888f999df1545eb97b8e76b0631afbb" => :el_capitan
    sha256 "d8bbe8d3e78821cd3785c7582ed7355ea74e966a3572abd92499db014907fefa" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
