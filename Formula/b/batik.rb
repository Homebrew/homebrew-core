class Batik < Formula
  desc "Java-based toolkit for SVG images"
  homepage "https://xmlgraphics.apache.org/batik/"
  url "https://www.apache.org/dyn/closer.lua?path=xmlgraphics/batik/binaries/batik-bin-1.19.tar.gz"
  mirror "https://archive.apache.org/dist/xmlgraphics/batik/binaries/batik-bin-1.19.tar.gz"
  sha256 "d4abb3845484bfe189a80f37419b94c77e66bd4b8bb9e5bf72ce70bc865edb22"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "acd7a808bfc88b232db45029fa1f85609d72b2f313cdf2e2b17a6c8f6e38c011"
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
      "/Library/Fonts/Arial Unicode.ttf"
    else
      "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
    end
    system bin/"batik-ttf2svg", font_path, "-autorange",
           "-o", "Arial.svg", "-testcard"
    assert_match "abcdefghijklmnopqrstuvwxyz", File.read("Arial.svg")
  end
end
