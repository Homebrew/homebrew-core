class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v2.0.18.tar.gz"
  sha256 "fad34373023f3212090635d7b793c2528e64c0593b2ba5c38b59f3fb6fd517f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "966b2a1a8e474335aaee4a1514b60798cd228460e2fd16ca361b34cc5327050b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "966b2a1a8e474335aaee4a1514b60798cd228460e2fd16ca361b34cc5327050b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acdef05b142ea26ac82e9bbf814e7caeeb2e91c34c73d028470c19ab49170bca"
    sha256 cellar: :any_skip_relocation, ventura:        "838217c6bd960cab0b8cee9f32b2b668c6744b52f7bf3302b788d067a0ff9861"
    sha256 cellar: :any_skip_relocation, monterey:       "838217c6bd960cab0b8cee9f32b2b668c6744b52f7bf3302b788d067a0ff9861"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ebc210dafcb38de14b1481019e74ad092bbe68cd4165418dd6724b706edf534"
    sha256 cellar: :any_skip_relocation, catalina:       "9ebc210dafcb38de14b1481019e74ad092bbe68cd4165418dd6724b706edf534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2fbcfc2cb751e46aff2a4f1cdd67501a479f0f8e780e15dca7bbc30cc6a286c"
  end

  uses_from_macos "ruby", since: :catalina

  # All of these resources are for the asciidoctor-pdf, coderay and rouge gems. To update the asciidoctor-pdf
  # resources, check https://rubygems.org/gems/asciidoctor-pdf for the latest dependency versions. Make sure to select
  # the correct version of each dependency gem because the allowable versions can differ between versions.
  # To help, click on "Show all transitive dependencies" for a tree view of all dependencies. I've added comments
  # above each resource to make updating them easier, but please update those comments as the dependencies change.

  # asciidoctor-pdf requires concurrent-ruby ~> 1.1
  resource "concurrent-ruby" do
    url "https://rubygems.org/gems/concurrent-ruby-1.1.9.gem"
    sha256 "0ec0846d991c38f355b4228ad8ea77aa69c3fdaa320cd574dafedc10c4688a5b"
  end

  # prawn 2.4.0 requires pdf-core ~> 0.9.0
  resource "pdf-core" do
    url "https://rubygems.org/gems/pdf-core-0.9.0.gem"
    sha256 "4f368b2f12b57ec979872d4bf4bd1a67e8648e0c81ab89801431d2fc89f4e0bb"
  end

  # prawn 2.4.0 requires ttfunk ~> 1.7
  # pdf-reader requires ttfunk
  resource "ttfunk" do
    url "https://rubygems.org/downloads/ttfunk-1.7.0.gem"
    sha256 "2370ba484b1891c70bdcafd3448cfd82a32dd794802d81d720a64c15d3ef2a96"
  end

  # asciidoctor-pdf requires prawn ~> 2.4.0
  # prawn-icon requires prawn >= 1.1.0, < 3.0.0
  # prawn-svg requires prawn >= 0.11.1, < 3
  # prawn-templates requires prawn ~> 2.2
  resource "prawn" do
    url "https://rubygems.org/gems/prawn-2.4.0.gem"
    sha256 "82062744f7126c2d77501da253a154271790254dfa8c309b8e52e79bc5de2abd"
  end

  # asciidoctor-pdf requires prawn-icon ~> 3.0.0
  resource "prawn-icon" do
    url "https://rubygems.org/gems/prawn-icon-3.0.0.gem"
    sha256 "dac8d481dee0f60a769c0cab0fd1baec7351b4806bf9ba959cd6c65f6694b6f5"
  end

  # addressable requires public_suffix >= 2.0.2, < 5.0
  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-4.0.6.gem"
    sha256 "a99967c7b2d1d2eb00e1142e60de06a1a6471e82af574b330e9af375e87c0cf7"
  end

  # css_parser requires addressable
  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.7.0.gem"
    sha256 "5e9b62fe1239091ea9b2893cd00ffe1bcbdd9371f4e1d35fac595c98c5856cbb"
  end

  # prawn-svg requires css_parser ~> 1.6
  resource "css_parser" do
    url "https://rubygems.org/gems/css_parser-1.11.0.gem"
    sha256 "568926c3193579446ad3e3f9d761c73e2918ee5b3b7757a1a49ec166c67d6de1"
  end

  # prawn-svq requires rexml ~> 3.2
  resource "rexml" do
    url "https://rubygems.org/gems/rexml-3.2.5.gem"
    sha256 "a33c3bf95fda7983ec7f05054f3a985af41dbc25a0339843bd2479e93cabb123"
  end

  # asciidoctor-pdf requires prawn-svg ~> 0.32.0
  resource "prawn-svg" do
    url "https://rubygems.org/gems/prawn-svg-0.32.0.gem"
    sha256 "66d1a20a93282528a25d5ad9e0db422dad4804a34e0892561b64c3930fff7d55"
  end

  # asciidoctor-pdf requires prawn-table ~> 0.2.0
  resource "prawn-table" do
    url "https://rubygems.org/gems/prawn-table-0.2.2.gem"
    sha256 "336d46e39e003f77bf973337a958af6a68300b941c85cb22288872dc2b36addb"
  end

  # pdf-reader requires afm ~> 0.2.1
  resource "afm" do
    url "https://rubygems.org/gems/afm-0.2.2.gem"
    sha256 "c83e698e759ab0063331ff84ca39c4673b03318f4ddcbe8e90177dd01e4c721a"
  end

  # pdf-reader requires Ascii85 ~> 1.0
  resource "Ascii85" do
    url "https://rubygems.org/gems/Ascii85-1.1.0.gem"
    sha256 "9ce694467bd69ab2349768afd27c52ad721cdc6f642aeaa895717bfd7ada44b7"
  end

  # pdf-reader requires hashery ~> 2.0
  resource "hashery" do
    url "https://rubygems.org/gems/hashery-2.1.2.gem"
    sha256 "d239cc2310401903f6b79d458c2bbef5bf74c46f3f974ae9c1061fb74a404862"
  end

  # pdf-reader requires ruby-rc4
  resource "ruby-rc4" do
    url "https://rubygems.org/gems/ruby-rc4-0.1.5.gem"
    sha256 "00cc40a39d20b53f5459e7ea006a92cf584e9bc275e2a6f7aa1515510e896c03"
  end

  # prawn-templates requires pdf-reader ~> 2.0
  resource "pdf-reader" do
    url "https://rubygems.org/gems/pdf-reader-2.4.2.gem"
    sha256 "26a27981377a856ccbcaddc5c3001eab7b887066c388351499b0a1e07b53b4b3"
  end

  # asciidoctor-pdf requries prawn-templates ~> 0.1.0
  resource "prawn-templates" do
    url "https://rubygems.org/gems/prawn-templates-0.1.2.gem"
    sha256 "117aa03db570147cb86fcd7de4fd896994f702eada1d699848a9529a87cd31f1"
  end

  # asciidoctor-pdf requries safe_yaml ~> 1.0.0
  resource "safe_yaml" do
    url "https://rubygems.org/gems/safe_yaml-1.0.5.gem"
    sha256 "a6ac2d64b7eb027bdeeca1851fe7e7af0d668e133e8a88066a0c6f7087d9f848"
  end

  # treetop requries polyglot ~> 0.3
  resource "polyglot" do
    url "https://rubygems.org/gems/polyglot-0.3.5.gem"
    sha256 "59d66ef5e3c166431c39cb8b7c1d02af419051352f27912f6a43981b3def16af"
  end

  # asciidoctor-pdf requries treetop ~> 1.6.0
  resource "treetop" do
    url "https://rubygems.org/gems/treetop-1.6.11.gem"
    sha256 "102e13adf065fc916eae60b9539a76101902a56e4283c847468eaea9c2c72719"
  end

  resource "asciidoctor-pdf" do
    url "https://rubygems.org/gems/asciidoctor-pdf-1.6.2.gem"
    sha256 "04385376cbc8d4d26e814b655e50189e58ecdeec2a4fa3ce9282943a3d3bd4c6"
  end

  resource "coderay" do
    url "https://rubygems.org/gems/coderay-1.1.3.gem"
    sha256 "dc530018a4684512f8f38143cd2a096c9f02a1fc2459edcfe534787a7fc77d4b"
  end

  resource "rouge" do
    url "https://rubygems.org/gems/rouge-3.26.0.gem"
    sha256 "a3deb40ae6a07daf67ace188b32c63df04cffbe3c9067ef82495d41101188b2c"
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
