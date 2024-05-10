class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/refs/tags/v2.0.22.tar.gz"
  sha256 "88b56b1fdd1bcfd097addc892c6071c76cb80409847f4765ae3e15d890543e6c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5246d326bd3ebc3ca46c683861b772bd3ccc1ecca7a66e99b3b6a5d95ed52dff"
    sha256 cellar: :any,                 arm64_ventura:  "9e90db02b036e7104cb3627ad8e08a231c5be1f1f12f33774830b8bb397a6d9c"
    sha256 cellar: :any,                 arm64_monterey: "faba63e3ac9b54bb1210a6c96f1d3bb15e110aecbd66370a4f7659e0cb778ade"
    sha256 cellar: :any,                 sonoma:         "118f8f236a7355fe36a12983f9e8c163410dfcf88ff2458611c7fbeaaacb96bf"
    sha256 cellar: :any,                 ventura:        "11938af6a1743c5e9ffa341b04cb1f6d55168a08dc6d0c3a602e890ad6a44c8a"
    sha256 cellar: :any,                 monterey:       "2d70b636a1c1e3ddd0a78333f614a577f12e8112bc66ee407545fa458f933e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "935bf4c659ed590726b66513ee110ea90940c28cbc15c8a4f82a24fdc07de519"
  end

  # Some gems require >= ruby 2.7
  depends_on "ruby"

  # Dependencies are for the asciidoctor-pdf, coderay, pygments.rb and rouge gems

  resource "polyglot" do
    url "https://rubygems.org/gems/polyglot-0.3.5.gem"
    sha256 "59d66ef5e3c166431c39cb8b7c1d02af419051352f27912f6a43981b3def16af"
  end

  resource "treetop" do
    url "https://rubygems.org/gems/treetop-1.6.12.gem"
    sha256 "ed48add684a2d7a8fd6e3b8b027d8ee5983b50977ae691913131a24f1746ac29"
  end

  resource "concurrent-ruby" do
    url "https://rubygems.org/gems/concurrent-ruby-1.2.3.gem"
    sha256 "82fdd3f8a0816e28d513e637bb2b90a45d7b982bdf4f3a0511722d2e495801e2"
  end

  resource "bigdecimal" do
    url "https://rubygems.org/gems/bigdecimal-3.1.6.gem"
    sha256 "bcbc27d449cf8ed1b1814d21308f49c9d22ce73e33fff0d228e38799c02eab01"
  end

  resource "ttfunk" do
    url "https://rubygems.org/gems/ttfunk-1.7.0.gem"
    sha256 "2370ba484b1891c70bdcafd3448cfd82a32dd794802d81d720a64c15d3ef2a96"
  end

  resource "pdf-core" do
    url "https://rubygems.org/gems/pdf-core-0.9.0.gem"
    sha256 "4f368b2f12b57ec979872d4bf4bd1a67e8648e0c81ab89801431d2fc89f4e0bb"
  end

  resource "prawn" do
    url "https://rubygems.org/gems/prawn-2.4.0.gem"
    sha256 "82062744f7126c2d77501da253a154271790254dfa8c309b8e52e79bc5de2abd"
  end

  resource "prawn-icon" do
    url "https://rubygems.org/gems/prawn-icon-3.0.0.gem"
    sha256 "dac8d481dee0f60a769c0cab0fd1baec7351b4806bf9ba959cd6c65f6694b6f5"
  end

  resource "rexml" do
    url "https://rubygems.org/gems/rexml-3.2.6.gem"
    sha256 "e0669a2d4e9f109951cb1fde723d8acd285425d81594a2ea929304af50282816"
  end

  resource "matrix" do
    url "https://rubygems.org/downloads/matrix-0.4.2.gem"
    sha256 "71083ccbd67a14a43bfa78d3e4dc0f4b503b9cc18e5b4b1d686dc0f9ef7c4cc0"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-5.0.4.gem"
    sha256 "35cd648e0d21d06b8dce9331d19619538d1d898ba6d56a6f2258409d2526d1ae"
  end

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.8.6.gem"
    sha256 "798f6af3556641a7619bad1dce04cdb6eb44b0216a991b0396ea7339276f2b47"
  end

  resource "css_parser" do
    url "https://rubygems.org/gems/css_parser-1.16.0.gem"
    sha256 "f70fb492254418522ea77c01d57bf64452d6c7465001926c3620d0b50289b1a2"
  end

  resource "prawn-svg" do
    url "https://rubygems.org/gems/prawn-svg-0.34.1.gem"
    sha256 "7c04e24bb5dbc8458ad86823f65973b2ef6e8ea68e12e1f7f92f8e3a209f4013"
  end

  resource "afm" do
    url "https://rubygems.org/gems/afm-0.2.2.gem"
    sha256 "c83e698e759ab0063331ff84ca39c4673b03318f4ddcbe8e90177dd01e4c721a"
  end

  resource "hashery" do
    url "https://rubygems.org/gems/hashery-2.1.2.gem"
    sha256 "d239cc2310401903f6b79d458c2bbef5bf74c46f3f974ae9c1061fb74a404862"
  end

  resource "ruby-rc4" do
    url "https://rubygems.org/gems/ruby-rc4-0.1.5.gem"
    sha256 "00cc40a39d20b53f5459e7ea006a92cf584e9bc275e2a6f7aa1515510e896c03"
  end

  resource "Ascii85" do
    url "https://rubygems.org/gems/Ascii85-1.1.0.gem"
    sha256 "9ce694467bd69ab2349768afd27c52ad721cdc6f642aeaa895717bfd7ada44b7"
  end

  resource "pdf-reader" do
    url "https://rubygems.org/gems/pdf-reader-2.12.0.gem"
    sha256 "61e72a4839cf2b3735a4b08dcb00e23c57a51d199494a5b11bd78e49d7b91758"
  end

  resource "prawn-templates" do
    url "https://rubygems.org/gems/prawn-templates-0.1.2.gem"
    sha256 "117aa03db570147cb86fcd7de4fd896994f702eada1d699848a9529a87cd31f1"
  end

  resource "prawn-table" do
    url "https://rubygems.org/gems/prawn-table-0.2.2.gem"
    sha256 "336d46e39e003f77bf973337a958af6a68300b941c85cb22288872dc2b36addb"
  end

  # asciidoctor supports the Python 3 pygments syntax highlighter via pygments.rb ~> 2.0.0
  # Unless pygments.rb is installed in the asciidoctor libexec gems folder, asciidoctor will
  # not be able to find the gem. Installing the pygment.rb gem as part of the main asciidoctor
  # formula ensures it's available if users choose to install and enable the Pygments syntax
  # highlighter.
  resource "pygments.rb" do
    url "https://rubygems.org/gems/pygments.rb-2.4.1.gem"
    sha256 "61a3c9a00c01d53fa5fe7f6f6d2c461abc5b50cf6db9438c04b812d80f8d94be"
  end

  resource "asciidoctor-pdf" do
    url "https://rubygems.org/gems/asciidoctor-pdf-2.3.14.gem"
    sha256 "24c1cc018118b5cbc57bdb35875ffa013bfd1653851e3513f1216cefea68e952"
  end

  resource "coderay" do
    url "https://rubygems.org/gems/coderay-1.1.3.gem"
    sha256 "dc530018a4684512f8f38143cd2a096c9f02a1fc2459edcfe534787a7fc77d4b"
  end

  resource "rouge" do
    url "https://rubygems.org/gems/rouge-4.2.0.gem"
    sha256 "60dd666b3a223467dc72f5b7384764dfd7ad4e50b0df9eff072be58123506eba"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "asciidoctor.gemspec"
    system "gem", "install", "asciidoctor-#{version}.gem"
    bin.install Dir[libexec/"bin/asciidoctor"]
    bin.install Dir[libexec/"bin/asciidoctor-pdf"]
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    man1.install_symlink "#{libexec}/gems/asciidoctor-#{version}/man/asciidoctor.1" => "asciidoctor.1"
  end

  test do
    %w[rouge coderay].each do |highlighter|
      (testpath/"test.adoc").atomic_write <<~EOS
        = AsciiDoc is Writing Zen
        Random J. Author <rjauthor@example.com>
        :icons: font
        :source-highlighter: #{highlighter}

        Hello, World!

        == Syntax Highlighting

        Python source.

        [source, python]
        ----
        import something
        ----

        List

        - one
        - two
        - three
      EOS
      output = Utils.popen_read bin/"asciidoctor", "-b", "html5", "-o", "test.html", "test.adoc", err: :out
      refute_match(/optional gem '#{highlighter}' is not available/, output)
      assert_match "<h1>AsciiDoc is Writing Zen</h1>", File.read("test.html")
      assert_match(/<pre class="#{highlighter} highlight">/i, File.read("test.html"))
      system bin/"asciidoctor", "-r", "asciidoctor-pdf", "-b", "pdf", "-o", "test.pdf", "test.adoc"
      assert_match "/Title (AsciiDoc is Writing Zen)", File.read("test.pdf", mode: "rb")
    end
  end
end
