class Dhcping < Formula
  desc "Perform a dhcp-request to check whether a dhcp-server is running"
  homepage "https://www.mavetju.org/unix/general.php"
  url "https://www.mavetju.org/download/dhcping-1.2.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/d/dhcping/dhcping_1.2.orig.tar.gz"
  sha256 "32ef86959b0bdce4b33d4b2b216eee7148f7de7037ced81b2116210bc7d3646a"

  bottle do
    cellar :any_skip_relocation
    sha256 "94dba411868455abd17d818d1009e71bae362cea093ec01437b19fbbb33a0cc2" => :mojave
    sha256 "e30ef14d867a06bcc9bcde18965fa00366780c3323841ca0fb25f864077044d6" => :high_sierra
    sha256 "5c41d596cb2a9835fc5f170ccd602294c98f163ba3f2a8d5c83bae252189817e" => :sierra
    sha256 "d3b03b1004d3a2d97b80fbbe9714bd29d006d9099a8f6baec343feb2833f3996" => :el_capitan
    sha256 "7741adb9bc166ee2450e521f7468e2b023632e737eb4da065848c5e87b6bd35a" => :yosemite
    sha256 "49206410d2fc5259798c2a76ee871df08c54772d1501d7ce1d29be652d600905" => :mavericks
    sha256 "4da8d1813dd16242c02ccea50549ac5eca0048475f9a6118b525677d6c72fda2" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
