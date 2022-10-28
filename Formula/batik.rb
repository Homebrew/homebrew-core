class Batik < Formula
  desc "Java-based toolkit for SVG images"
  homepage "https://xmlgraphics.apache.org/batik/"
  url "https://www.apache.org/dyn/closer.lua?path=xmlgraphics/batik/binaries/batik-bin-1.16.tar.gz"
  mirror "https://archive.apache.org/dist/xmlgraphics/batik/binaries/batik-bin-1.16.tar.gz"
  sha256 "6386c9e97e3ab0ac75f9f98d90e4b6454ee09fb9f47ca0e790e60cab44bc7d83"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca18391889d2f3ff94fce3367415612d85537d095f8c514dff8e29e2c6b6de7d"
  end

  depends_on "openjdk"

  def install
    libexec.install "lib", Dir["*.jar"]
    Dir[libexec/"*.jar"].each do |f|
      bin.write_jar_script f, File.basename(f, "-#{version}.jar")
    end
  end

  test do
    font_name = (MacOS.version >= :catalina) ? "Arial Unicode.ttf" : "Arial.ttf"
    font_path = if OS.mac?
      "/Library/Fonts/#{font_name}"
    else
      "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
    end
    system bin/"batik-ttf2svg", font_path, "-autorange",
           "-o", "Arial.svg", "-testcard"
    assert_match "abcdefghijklmnopqrstuvwxyz", File.read("Arial.svg")
  end
end
