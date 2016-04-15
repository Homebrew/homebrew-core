class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "http://iperf.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/iperf/iperf-2.0.5.tar.gz"
  sha256 "636b4eff0431cea80667ea85a67ce4c68698760a9837e1e9d13096d20362265b"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "4fabcfbc462ea67189847e6faba598a5952bd155e292696cfd39f4d709f926a2" => :el_capitan
    sha256 "37e46ed0ee35a3f0957d847ce4afc871c352108279f8c001c7879282a8706495" => :yosemite
    sha256 "67d2c2cef38fc34704f379a0dcf7d32d0b1bd5d30cd44f0533a6bd55f275bb8a" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
