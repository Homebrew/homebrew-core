class Mpc < Formula
  desc "Command-line music player client for mpd"
  homepage "https://www.musicpd.org/clients/mpc/"
  url "https://www.musicpd.org/download/mpc/0/mpc-0.28.tar.gz"
  sha256 "53385c2d9af0a0025943045b46cb2079b300c1224d615ac98f7ff140e968600d"

  bottle do
    cellar :any
    sha256 "b9ccf41dbf3c86770df6bcc89b8d536ddaf5a7db6d3830baba0befc2f0ab2ea6" => :el_capitan
    sha256 "8cc20e2845ff22ed345dcdb1fe018d50e3ceb208193e1a4e7fc414bc5e825a42" => :yosemite
    sha256 "0b2c7bf14d9ca916295e29784d8bc4d75637c86d9bf8d4c59713d54fcc6d9b31" => :mavericks
    sha256 "c80bf07b0a0e3c30cb4d4dd4d4a3da5479c43b9a1be389ed8e164e5e618a8ac3" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libmpdclient"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
