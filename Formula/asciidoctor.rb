class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v1.5.7.tar.gz"
  sha256 "92234373a428924da71eeab673fc70abeb533a226ac24d4db6f9e38a8bfa28f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "706d1a92697057a45787d5e3b31d36bf96d50ca10454f53075038f902fc8164a" => :high_sierra
    sha256 "71c99d6310db8ab951d2c42dbbd3117aae0d8443a5ae1ba4725ed20c81df00a5" => :sierra
    sha256 "c7531d673926d06f0dcf3d0143d5cf39e88072f368954f63025df18cca1ef84a" => :el_capitan
  end

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "asciidoctor.gemspec"
    system "gem", "install", "asciidoctor-#{version}.gem"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    (testpath/"test.adoc").write("= AsciiDoc is Writing Zen")
    system bin/"asciidoctor", "-b", "html5", "-o", "test.html", "test.adoc"
    assert_match "<h1>AsciiDoc is Writing Zen</h1>", File.read("test.html")
  end
end
