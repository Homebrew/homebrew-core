class Batik < Formula
  desc "Java-based toolkit for SVG images"
  homepage "https://xmlgraphics.apache.org/batik/"
  url "https://www.apache.org/dyn/closer.lua?path=xmlgraphics/batik/binaries/batik-bin-1.18.tar.gz"
  mirror "https://archive.apache.org/dist/xmlgraphics/batik/binaries/batik-bin-1.18.tar.gz"
  sha256 "936902ff8e35a34aa2cd8f67c1b5898771efe391497ae0e0ae1ca73e1bd98346"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dc1915341d14ca4382529ecaf9380335e11d318ede8af0a0054bb3ee4dde65d9"
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
