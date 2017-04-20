class Libdvbpsi < Formula
  desc "Library to decode/generate MPEG TS and DVB PSI tables"
  homepage "https://www.videolan.org/developers/libdvbpsi.html"
  url "https://download.videolan.org/pub/libdvbpsi/1.3.1/libdvbpsi-1.3.1.tar.bz2"
  sha256 "d68367afd5ad8e6ebca813e7958a3ceb9743b421adb4265eceeb6a3511c84420"

  bottle do
    cellar :any
    sha256 "8f59f8abb62f324c1898be55e219192245eaab01fca96bd1f5e4e5d650d23862" => :sierra
    sha256 "dd6206de7987a2dcc315e36725bf82565e36651c6004d9ede3efbcc3614323b2" => :el_capitan
    sha256 "c85ff88dc9ccb4d9474d78c8b0dce4ee4926d5129bc7bf2b35dac3cbb47dbe06" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-release"
    system "make", "install"
  end
end
