class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v2.0.8.tar.gz"
  sha256 "16a7b06b24e21ff3047e83b5830f2daac1a30fb6b1e78bd3af0583242e88ca6b"

  depends_on "ruby" if MacOS.version <= :sierra

  bottle do
    cellar :any_skip_relocation
    sha256 "b45b4b0b19b41f2d2e27eb83818bd066fff37c515f631a9117f7728366dcd30f" => :mojave
    sha256 "3fd501546687cd9fd07e00a9552514f3c3c4fd88c51ae5bebd72155f0d431004" => :high_sierra
    sha256 "9e92f9929b1256fd9c0a8cc37e4f2dcacc36ac0fa9a60aeac16e34df2b388a81" => :sierra
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
