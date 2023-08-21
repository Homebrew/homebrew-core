class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v2.0.20.tar.gz"
  sha256 "e38d8e15e0bf0f28811e35e3e24ca30b9f5424669ffd9e8e4c208b21f45dbdea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "987d9a5584cd331ed4c922c595e1e25e24314def4deaef7bd9c2764d74727224"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "987d9a5584cd331ed4c922c595e1e25e24314def4deaef7bd9c2764d74727224"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "987d9a5584cd331ed4c922c595e1e25e24314def4deaef7bd9c2764d74727224"
    sha256 cellar: :any_skip_relocation, ventura:        "9833ecbbc05e19319c2ddb83c5310a05202bad47dfa5fb739c01e27f6ddbbd55"
    sha256 cellar: :any_skip_relocation, monterey:       "9833ecbbc05e19319c2ddb83c5310a05202bad47dfa5fb739c01e27f6ddbbd55"
    sha256 cellar: :any_skip_relocation, big_sur:        "9833ecbbc05e19319c2ddb83c5310a05202bad47dfa5fb739c01e27f6ddbbd55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c05e33e2d036fc68a2b6cb4489108f241d1daa445d68534ebcbafde9c47a05dd"
  end

  # Some gems require >= ruby 2.7
  depends_on "ruby"

  # Dependencies are for the asciidoctor-pdf, coderay, pygments.rb and rouge gems
  # https://rubygems.org/gems/asciidoctor-pdf/versions/2.3.7/dependencies

  # asciidoctor-pdf 2.3.7 -> concurrent-ruby 1.2.2
  resource "concurrent-ruby" do
    url "https://rubygems.org/gems/concurrent-ruby-1.2.2.gem"
    sha256 "3879119b8b75e3b62616acc256c64a134d0b0a7a9a3fcba5a233025bcde22c4f"
  end

  # asciidoctor-pdf 2.3.7 -> matrix 0.4.2
  resource "matrix" do
    url "https://rubygems.org/downloads/matrix-0.4.2.gem"
    sha256 "71083ccbd67a14a43bfa78d3e4dc0f4b503b9cc18e5b4b1d686dc0f9ef7c4cc0"
  end

  # asciidoctor-pdf 2.3.7 -> prawn 2.4.0 -> pdf-core 0.9.0
  resource "pdf-core" do
    url "https://rubygems.org/gems/pdf-core-0.9.0.gem"
    sha256 "4f368b2f12b57ec979872d4bf4bd1a67e8648e0c81ab89801431d2fc89f4e0bb"
  end

  # asciidoctor-pdf 2.3.7 -> prawn 2.4.0 -> ttfunk 1.7.0
  resource "ttfunk" do
    url "https://rubygems.org/gems/ttfunk-1.7.0.gem"
    sha256 "2370ba484b1891c70bdcafd3448cfd82a32dd794802d81d720a64c15d3ef2a96"
  end

  # asciidoctor-pdf 2.3.7 -> prawn 2.4.0
  resource "prawn" do
    url "https://rubygems.org/gems/prawn-2.4.0.gem"
    sha256 "82062744f7126c2d77501da253a154271790254dfa8c309b8e52e79bc5de2abd"
  end

  # asciidoctor-pdf 2.3.7 -> prawn-icon -> 3.0.0
  resource "prawn-icon" do
    url "https://rubygems.org/gems/prawn-icon-3.0.0.gem"
    sha256 "dac8d481dee0f60a769c0cab0fd1baec7351b4806bf9ba959cd6c65f6694b6f5"
  end

  # asciidoctor-pdf 2.3.7 -> prawn-sv 0.32.0 -> css_parser 1.14.0 -> addressable 2.8.4 -> public_suffix 5.0.1
  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-5.0.1.gem"
    sha256 "65603917ff4ecb32f499f42c14951aeed2380054fa7fc51758fc0a8d455fe043"
  end

  # asciidoctor-pdf 2.3.7 -> prawn-sv 0.32.0 -> css_parser 1.14.0 -> addressable 2.8.4
  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.8.4.gem"
    sha256 "40a88af5285625b7fb14070e550e667d5b0cc91f748068701b4d897cacda4897"
  end

  # asciidoctor-pdf 2.3.7 -> prawn-sv 0.32.0 -> css_parser 1.14.0
  resource "css_parser" do
    url "https://rubygems.org/gems/css_parser-1.14.0.gem"
    sha256 "f2ce6148cd505297b07bdbe7a5db4cce5cf530071f9b732b9a23538d6cdc0113"
  end

  # asciidoctor-pdf 2.3.7 -> prawn-sv 0.32.0 -> rexml 3.2.5
  resource "rexml" do
    url "https://rubygems.org/gems/rexml-3.2.5.gem"
    sha256 "a33c3bf95fda7983ec7f05054f3a985af41dbc25a0339843bd2479e93cabb123"
  end

  # asciidoctor-pdf 2.3.7 -> prawn-sv 0.32.0
  resource "prawn-svg" do
    url "https://rubygems.org/gems/prawn-svg-0.32.0.gem"
    sha256 "66d1a20a93282528a25d5ad9e0db422dad4804a34e0892561b64c3930fff7d55"
  end

  # asciidoctor-pdf 2.3.7 -> prawn-table ~> 0.2.2
  resource "prawn-table" do
    url "https://rubygems.org/gems/prawn-table-0.2.2.gem"
    sha256 "336d46e39e003f77bf973337a958af6a68300b941c85cb22288872dc2b36addb"
  end

  # asciidoctor-pdf 2.3.7 -> prawn-templates 0.1.2 -> pdf-reader 2.11.0 -> afm 0.2.2
  resource "afm" do
    url "https://rubygems.org/gems/afm-0.2.2.gem"
    sha256 "c83e698e759ab0063331ff84ca39c4673b03318f4ddcbe8e90177dd01e4c721a"
  end

  # asciidoctor-pdf 2.3.7 -> prawn-templates 0.1.2 -> pdf-reader 2.11.0 -> Ascii85 1.1.0ew
  resource "Ascii85" do
    url "https://rubygems.org/gems/Ascii85-1.1.0.gem"
    sha256 "9ce694467bd69ab2349768afd27c52ad721cdc6f642aeaa895717bfd7ada44b7"
  end

  # asciidoctor-pdf 2.3.7 -> prawn-templates 0.1.2 -> pdf-reader 2.11.0 -> hashery 2.1.2
  resource "hashery" do
    url "https://rubygems.org/gems/hashery-2.1.2.gem"
    sha256 "d239cc2310401903f6b79d458c2bbef5bf74c46f3f974ae9c1061fb74a404862"
  end

  # asciidoctor-pdf 2.3.7 - > prawn-templates 0.1.2 -> pdf-reader 2.11.0 -> ruby-rc4 0.1.5
  resource "ruby-rc4" do
    url "https://rubygems.org/gems/ruby-rc4-0.1.5.gem"
    sha256 "00cc40a39d20b53f5459e7ea006a92cf584e9bc275e2a6f7aa1515510e896c03"
  end

  # asciidoctor-pdf 2.3.7 -> prawn-templates 0.1.2 -> pdf-reader 2.11.0 -> ttfunk 1.7.0
  resource "ttfunk" do
    url "https://rubygems.org/gems/ttfunk-1.7.0.gem"
    sha256 "2370ba484b1891c70bdcafd3448cfd82a32dd794802d81d720a64c15d3ef2a96"
  end

  # asciidoctor-pdf 2.3.7 -> prawn-templates 0.1.2 -> pdf-reader 2.11.0
  resource "pdf-reader" do
    url "https://rubygems.org/gems/pdf-reader-2.11.0.gem"
    sha256 "03238525f98340f7598ce5e292a2cbe8a87f9a2a5617c8cdd5e2467b65115d27"
  end

  # asciidoctor-pdf 2.3.7 -> prawn-templates 0.1.2
  resource "prawn-templates" do
    url "https://rubygems.org/gems/prawn-templates-0.1.2.gem"
    sha256 "117aa03db570147cb86fcd7de4fd896994f702eada1d699848a9529a87cd31f1"
  end

  # asciidoctor-pdf 2.3.7 -> treetop 1.6.12 -> polyglot 0.3.5
  resource "polyglot" do
    url "https://rubygems.org/gems/polyglot-0.3.5.gem"
    sha256 "59d66ef5e3c166431c39cb8b7c1d02af419051352f27912f6a43981b3def16af"
  end

  # asciidoctor-pdf 2.3.7 -> treetop 1.6.12
  resource "treetop" do
    url "https://rubygems.org/gems/treetop-1.6.12.gem"
    sha256 "ed48add684a2d7a8fd6e3b8b027d8ee5983b50977ae691913131a24f1746ac29"
  end

  # asciidoctor supports the Python 3 pygments syntax highlighter via pygments.rb ~> 2.0.0
  # Unless pygments.rb is installed in the asciidoctor libexec gems folder, asciidoctor will
  # not be able to find the gem. Installing the pygment.rb gem as part of the main asciidoctor
  # formula ensures it's available if users choose to install and enable the Pygments syntax
  # highlighter.
  resource "pygments.rb" do
    url "https://rubygems.org/gems/pygments.rb-2.4.0.gem"
    sha256 "2f236c8deac651b3c61623ed9252e60344cdd1f18cd6bf563f16d44143591320"
  end

  # asciidoctor-pdf 2.3.7
  resource "asciidoctor-pdf" do
    url "https://rubygems.org/gems/asciidoctor-pdf-2.3.7.gem"
    sha256 "8dda110d1a50346f0d9b01790640d7f17b0bcb940346452143d05ec80ed58e20"
  end

  # coderay 1.1.3
  resource "coderay" do
    url "https://rubygems.org/gems/coderay-1.1.3.gem"
    sha256 "dc530018a4684512f8f38143cd2a096c9f02a1fc2459edcfe534787a7fc77d4b"
  end

  # rouge 4.1.1
  resource "rouge" do
    url "https://rubygems.org/gems/rouge-4.1.1.gem"
    sha256 "41cc3ed28de7a9f5c0145bcdbeae8f5c16133065d570e21393aac935a235fd4b"
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
