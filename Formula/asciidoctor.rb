class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v2.0.10.tar.gz"
  sha256 "afca74837e6d4b339535e8ba0b79f2ad00bd1eef78bf391cc36995ca2e31630a"

  depends_on "ruby" if MacOS.version <= :sierra

  bottle do
    cellar :any_skip_relocation
    sha256 "4cba32b552a0cb489858fe910a63334a4c722f44bb80bccbbe642f1ab73ae65f" => :mojave
    sha256 "cc426b5e309721748eab5155e1f08566c73535e7bb4c48a7a25ca98a29d7939e" => :high_sierra
    sha256 "00391894934b25320c75e542b956aa4b2c05d9634fb3e636e062dbd3036a0736" => :sierra
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
