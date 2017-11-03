class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "http://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v1.5.6.1.tar.gz"
  sha256 "27e238f4cc48c19e1060ec8770a1c6eb55c3b837d9063aa99bc37e38d76b4a48"

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
