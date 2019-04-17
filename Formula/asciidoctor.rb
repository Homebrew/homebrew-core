class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v2.0.7.tar.gz"
  sha256 "2403354563f545441e7db8edd156afe9b0bdb175a42160e8f4934dce5466324f"

  depends_on "ruby" if MacOS.version <= :sierra

  bottle do
    cellar :any_skip_relocation
    sha256 "1c8149614b24bf16bbe8c851b8a0a6d9af59c449bb8bbb7dd3e72fa8aa352c04" => :mojave
    sha256 "585163fda781359d82a2f07dedb84f1f73cd4f0e353e905ff10a4d477bbc0963" => :high_sierra
    sha256 "9125825613e21dc563d0c57520e902e654bef1d9c5231a5d6a976088e483d5be" => :sierra
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
