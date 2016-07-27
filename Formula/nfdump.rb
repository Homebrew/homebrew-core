class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command line"
  homepage "http://nfdump.sourceforge.net"
  url "https://github.com/phaag/nfdump.git",
    :tag => "v1.6.15",
    :revision => "68d660e984e8b6ce099fc7309f61f3bfa460598f"
    
  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "e6218ff15aa6e43f140d91a38f8162ba663a115fcdb843c3a22de5fcda30653e" => :el_capitan
    sha256 "a56146c191cf705b83cdd0e0143ce9fc87f086386d9965ff54a259c085130697" => :yosemite
    sha256 "09a51a71d30f8045075f11f8511a4ec0d6bfd6f9d3cbc3bbb2927c911fce1ce1" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-readpcap"
    system "make", "install"
  end

  test do
    system "#{bin}/nfdump", "-Z 'host 8.8.8.8'"
  end
end
