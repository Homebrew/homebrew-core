class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v2.0.10.tar.gz"
  sha256 "afca74837e6d4b339535e8ba0b79f2ad00bd1eef78bf391cc36995ca2e31630a"

  depends_on "ruby" if MacOS.version <= :sierra

  bottle do
    cellar :any_skip_relocation
    sha256 "db8e26deff7e7a32c6b08620ff4d7a167f080cf0ac13ed21581faf0c50887247" => :catalina
    sha256 "3a76289cb376285952c46a17ebc44c24f5c56bc6cc5219507321d9745963f23b" => :mojave
    sha256 "36b22c4bba82748fbd212c2bc0c4726aff9850addeea7b7df2ac707b0728034c" => :high_sierra
    sha256 "48f283b4f49a361a4a1aedc433996345edb49e8de0d039e9c35cadf0830e33b4" => :sierra
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
