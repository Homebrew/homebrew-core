class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v1.5.7.tar.gz"
  sha256 "92234373a428924da71eeab673fc70abeb533a226ac24d4db6f9e38a8bfa28f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3b6b783d9cfdd2e246ff0d268f54e987a1811f576b7c30aa86c29c107832692" => :high_sierra
    sha256 "d51bb5e45f6d3159f137521409c00d63ba7a50270400ff10db57b98fce395d37" => :sierra
    sha256 "e026b825b046eef21690d77e40d5dce3477165e91f95b4863dad411707a5d980" => :el_capitan
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
