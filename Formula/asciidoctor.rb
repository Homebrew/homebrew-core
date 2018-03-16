class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v1.5.6.1.tar.gz"
  sha256 "27e238f4cc48c19e1060ec8770a1c6eb55c3b837d9063aa99bc37e38d76b4a48"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a4781de566088ef6f3bca77353934e795294380bd67c56a1f30bdd4a8430e4b" => :high_sierra
    sha256 "b88ab76f368387aa393758941d556cfec66c0415c2cad3a1c896b059996c0aa5" => :sierra
    sha256 "9b4f5f4268400fc71ad4b31c7cb05135f342ab5f31df99a155cf3cf749572f94" => :el_capitan
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
