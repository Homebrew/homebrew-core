class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/1.8.1.tar.gz"
  sha256 "dfa1e97f3a91af00da45af1bf3f6a197f545063dba129bd4db839b0139e68e24"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2c1dbd01cb3eb5f0501250894b8886012501bdfd197c6b7e69a917ea8ce57de" => :sierra
    sha256 "b2c1dbd01cb3eb5f0501250894b8886012501bdfd197c6b7e69a917ea8ce57de" => :el_capitan
    sha256 "b2c1dbd01cb3eb5f0501250894b8886012501bdfd197c6b7e69a917ea8ce57de" => :yosemite
  end

  depends_on "screenresolution" => :recommended
  depends_on "imagemagick" => :recommended

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch", "--test", "--config off"
  end
end
