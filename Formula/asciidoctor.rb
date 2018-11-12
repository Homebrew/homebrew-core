class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v1.5.8.tar.gz"
  sha256 "bc225145feb7876bce5188aa3ef511fad49b141ec18e1bb60e69b33b0a100da0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e5dd5c505d5c53fd2f422f3745ba0bec84cb9b4a7b68f11a6938e39f8bc75a0" => :mojave
    sha256 "43af3ac916a5549418cf47c82b78730a15b80def87e6b93bccbf8994eb7038cf" => :high_sierra
    sha256 "49741f10a1616dcae23ad2feb9d2758824fb97253d9135a387e27840ce4260a3" => :sierra
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
