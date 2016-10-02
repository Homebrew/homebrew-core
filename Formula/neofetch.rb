class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/1.8.tar.gz"
  sha256 "bcff4071cc001f050ec41e844058eb79d491a403dc53ca5fc57be4015b2052b6"
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
