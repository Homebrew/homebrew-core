class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v2.0.8.tar.gz"
  sha256 "16a7b06b24e21ff3047e83b5830f2daac1a30fb6b1e78bd3af0583242e88ca6b"

  depends_on "ruby" if MacOS.version <= :sierra

  bottle do
    cellar :any_skip_relocation
    sha256 "e7eb4ddb61f1dd46629e5ca198e025c6f8a27f63065d69ed07726e95f6acf6b3" => :mojave
    sha256 "48a3a249924215fbe57fb9f8030d47d234624c8d49ae37199ab38e021091b94c" => :high_sierra
    sha256 "156973895c880fb6171c1daade7006e2284d87fb440d6cfa61522268a4441d41" => :sierra
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
