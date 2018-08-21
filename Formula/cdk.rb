class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20180306.tgz"
  version "5.0.20180306"
  sha256 "cca9e345c6728c235eb3188af9266327c09c01da124a30b0cbd692ac08c6ebd0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d5c973c46791f4aaceb9e343cb57029f28327ea94fa480f2601872b60e8fb24" => :mojave
    sha256 "4fa97741c58623aedd6f8e41147cf503b21a318ae035341871212841bab0fbb0" => :high_sierra
    sha256 "58c136c407b21c5d34db2ae0f206887639f4077482a607060010ba172a6c1433" => :sierra
    sha256 "7d8e6706f54a83fe58b0ae7480bc7ff0fff3374a1d3f4615286057c336f31c37" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end
