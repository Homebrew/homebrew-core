class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v1.5.8.tar.gz"
  sha256 "bc225145feb7876bce5188aa3ef511fad49b141ec18e1bb60e69b33b0a100da0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a72d25edb4069881295094ed39f7bc0d3b1aeef3cb8dbe55df06291b7c87330" => :mojave
    sha256 "b31c91e2218a7d877243bf973519644552bfa6775f0afb9cee9e7964450be7a1" => :high_sierra
    sha256 "56ff379da06e486b925ac6bfc1459a8810243c54118a4088b70b3af463a26851" => :sierra
    sha256 "b2cada743cbac6d0f36ea211cc9bbf6b0fba53264ff04fc7be95141ddbc2a2d1" => :el_capitan
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
