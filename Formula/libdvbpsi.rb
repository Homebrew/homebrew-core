class Libdvbpsi < Formula
  desc "Library to decode/generate MPEG TS and DVB PSI tables"
  homepage "https://www.videolan.org/developers/libdvbpsi.html"
  url "https://download.videolan.org/pub/libdvbpsi/1.3.3/libdvbpsi-1.3.3.tar.bz2"
  sha256 "02b5998bcf289cdfbd8757bedd5987e681309b0a25b3ffe6cebae599f7a00112"

  bottle do
    cellar :any
    sha256 "b6e6f300bbc36fabf785f74abb083c5cfc3f91fdd51ee7bd058cc579e709c78d" => :catalina
    sha256 "26298540d01f52628385c83cac4b6666543af4cc059fa7ad5b3a8bd458955628" => :mojave
    sha256 "c6d79686bf05346bc473cc148b68901d99ac447a85542ff68d089c71eda1bc87" => :high_sierra
    sha256 "8bb1f1fff61674756153e8aec744d5d3c726da0c4ecd4bd291cae732e8264af3" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-release"
    system "make", "install"
  end
end
