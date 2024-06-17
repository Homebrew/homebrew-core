class Batik < Formula
  desc "Java-based toolkit for SVG images"
  homepage "https://xmlgraphics.apache.org/batik/"
  url "https://www.apache.org/dyn/closer.lua?path=xmlgraphics/batik/binaries/batik-bin-1.17.tar.gz"
  mirror "https://archive.apache.org/dist/xmlgraphics/batik/binaries/batik-bin-1.17.tar.gz"
  sha256 "b04269845de0ae5c19084b778071e6e0917c469bca2812cbbca5dfda5bbf7610"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2ada2cda21b8acfdd5975cc1723fe9b780d5c0fcbf372ad60c6680e5a351dead"
  end

  depends_on "openjdk"

  def install
    libexec.install "lib", Dir["*.jar"]
    Dir[libexec/"*.jar"].each do |f|
      bin.write_jar_script f, File.basename(f, "-#{version}.jar")
    end
  end

  test do
    font_path = if OS.mac?
      font_name = (MacOS.version >= :catalina) ? "Arial Unicode.ttf" : "Arial.ttf"
      "/Library/Fonts/#{font_name}"
    else
      "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
    end
    system bin/"batik-ttf2svg", font_path, "-autorange",
           "-o", "Arial.svg", "-testcard"
    assert_match "abcdefghijklmnopqrstuvwxyz", File.read("Arial.svg")
  end
end
