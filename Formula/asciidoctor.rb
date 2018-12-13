class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v1.5.8.tar.gz"
  sha256 "bc225145feb7876bce5188aa3ef511fad49b141ec18e1bb60e69b33b0a100da0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0cd37a53d270739c7798368d25762ecfdd4f962a6dd65805775940985f822c84" => :mojave
    sha256 "8e11a9703b0ce01f19e64065fb296b18a2eee334c2630cb4aa5fb3bfd36ddf9c" => :high_sierra
    sha256 "de3c2471e4afa84af77b5a5e6e78443c4b6f297d2f6da03e64d62ce1f2ac8491" => :sierra
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
