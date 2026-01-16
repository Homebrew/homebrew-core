class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/refs/tags/v2.0.26.tar.gz"
  sha256 "25c22b934bc0ae2448f2d73d4b2eba0c59e0521cf5e893fb0b0ad54a461bf066"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "83482da376e6cbc52582198a08c0a04cd652f0560df93c5c496bed02053cc818"
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
    url "https://rubygems.org/gems/public_suffix-5.0.5.gem"
    sha256 "72c340218bb384610536919988705cc29e09749c0021fd7005f715c7e5dfc493"
  end

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.8.6.gem"
    sha256 "798f6af3556641a7619bad1dce04cdb6eb44b0216a991b0396ea7339276f2b47"
  end

  resource "css_parser" do
    url "https://rubygems.org/gems/css_parser-1.17.1.gem"
    sha256 "eb730f2d26591a843e52bd3d0efd76abdfeec8bad728e0b2ac821fc10bb018e6"
  end

  resource "prawn-svg" do
    url "https://rubygems.org/gems/prawn-svg-0.34.2.gem"
    sha256 "afff79d332940f6d59604d0b2810f54d46e9335533a2aa4e892fb7d514777a90"
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
    url "https://rubygems.org/gems/Ascii85-1.1.1.gem"
    sha256 "73d760d093bf997e88c2a4d0bfe4328e838e0799915aee6b3162836c5267c2b0"
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
    url "https://rubygems.org/gems/pygments.rb-3.0.0.gem"
    sha256 "41729ecc69624bd3fc6bcc13d6ccb6ff0263334c42f66bfcf517a120addbb093"
  end

  resource "asciidoctor-pdf" do
    url "https://rubygems.org/gems/asciidoctor-pdf-2.3.15.gem"
    sha256 "432effdefdcd6433a797b702422b5f6fd4120c495c5f75ae059159aa75aa9a94"
  end

  resource "coderay" do
    url "https://rubygems.org/gems/coderay-1.1.3.gem"
    sha256 "dc530018a4684512f8f38143cd2a096c9f02a1fc2459edcfe534787a7fc77d4b"
  end

  resource "rouge" do
    url "https://rubygems.org/gems/rouge-4.2.1.gem"
    sha256 "f371732db127913fe10f13b1c25500b927539167a746dc8ee8089ad868bba1fd"
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
