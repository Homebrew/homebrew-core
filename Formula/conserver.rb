class Conserver < Formula
  desc "Allows multiple users to watch a serial console at the same time"
  homepage "https://www.conserver.com/"
  url "https://github.com/conserver/conserver/releases/download/v8.2.3/conserver-8.2.3.tar.gz"
  sha256 "764443b2798047f7429747510eeb3207240260590551700d13dbbad8a5bdee08"

  bottle do
    sha256 "3332bc506c85754b3b601989941613c83932ea28b4fb8aef87e45dfa576807c2" => :mojave
    sha256 "3fca2dc202bf6d68cc8294be8c2703bef813ad6583d51c3d9c4da12dbc975a89" => :high_sierra
    sha256 "c3885b3a01be7c4d0a4ed943906c4cb13be485b770271ac94cf9e439fdb9ca9a" => :sierra
    sha256 "d9f2d169e4a3adf0e46b7047991dba382147da1bd0923969bd0bec7bf7f14900" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    console = fork do
      exec bin/"console", "-n", "-p", "8000", "test"
    end
    sleep 1
    Process.kill("TERM", console)
  end
end
