class Batik < Formula
  desc "Java-based toolkit for SVG images"
  homepage "https://xmlgraphics.apache.org/batik/"
  url "https://www.apache.org/dyn/closer.lua?path=xmlgraphics/batik/binaries/batik-bin-1.12.tar.gz"
  sha256 "9d185a73db6b6fafb11c8c3edc6936de766d08606497e493126ba751585051f0"

  bottle :unneeded

  def install
    libexec.install "lib", Dir["*.jar"]
    bin.write_jar_script libexec/"batik-rasterizer-#{version}.jar", "batik-rasterizer"
    bin.write_jar_script libexec/"batik-#{version}.jar", "batik"
    bin.write_jar_script libexec/"batik-ttf2svg-#{version}.jar", "batik-ttf2svg"
  end

  test do
    font_name = (MacOS.version >= :catalina) ? "Arial Unicode.ttf" : "Arial.ttf"
    system bin/"batik-ttf2svg", "/Library/Fonts/#{font_name}", "-autorange",
           "-o", "Arial.svg", "-testcard"
    assert_match "abcdefghijklmnopqrstuvwxyz", File.read("Arial.svg")
  end
end
