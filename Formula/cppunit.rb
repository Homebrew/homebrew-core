class Cppunit < Formula
  desc "Unit testing framework for C++"
  homepage "https://wiki.freedesktop.org/www/Software/cppunit/"
  url "https://dev-www.libreoffice.org/src/cppunit-1.14.0.tar.gz"
  sha256 "3d569869d27b48860210c758c4f313082103a5e58219a7669b52bfd29d674780"

  bottle do
    cellar :any
    sha256 "6a5f121673ff3abbb3c414bc549fca92207de96df5e61c355ff618a3c2d48fed" => :catalina
    sha256 "3a62b16c2f36115f58f28277602c2cda352bb8e3dc5d559708db19f22ac5eb9e" => :mojave
    sha256 "2740f149428280c1dd20ac94612eacca944d29dac0838eee4eeb0eef2ae1fdd6" => :high_sierra
    sha256 "3c620068fba4bf15b6138ffc4042ab2111a67201310523104c07c314115520bb" => :sierra
    sha256 "a2d2bf8be8ffb614f0490801e38558681b8b01a9fc7ff4be5f785d3db7f71157" => :el_capitan
    sha256 "8078fbe4b7fd092a197c452af4caf3f5eaeb27dce16afd46e1da2a1ec1ae7f6d" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/DllPlugInTester", 2)
  end
end
