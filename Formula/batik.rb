class Batik < Formula
  desc "Java-based toolkit for SVG images"
  homepage "https://xmlgraphics.apache.org/batik/"
  url "https://www.apache.org/dist/xmlgraphics/batik/binaries/batik-bin-1.10.tar.gz"
  sha256 "226b3910a8bdc642c8e3a512f34a9b19bf942c17fef3ad7dc901ac34a2714322"

  bottle :unneeded

  def install
    libexec.install "lib", Dir["*.jar"]
    bin.write_jar_script libexec/"batik-rasterizer-#{version}.jar", "batik-rasterizer"
    bin.write_jar_script libexec/"batik-#{version}.jar", "batik"
    bin.write_jar_script libexec/"batik-ttf2svg-#{version}.jar", "batik-ttf2svg"
  end

  test do
    system bin/"batik-ttf2svg", "/Library/Fonts/Webdings.ttf", "-autorange",
           "-o", "Webdings.svg", "-testcard"
    assert_match "abcdefghijklmnopqrstuvwxyz", File.read("Webdings.svg")
  end
end
