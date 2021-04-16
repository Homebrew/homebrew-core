class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v2.0.13.tar.gz"
  sha256 "4812dd15bb71b3ae8351e8e3c2df4528c7c40dd97ef1954a56442b56b59019a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5f9ca51b3374baec623240ec160ef48bf04d0cb49d734b1018b012431a0fda02"
    sha256 cellar: :any_skip_relocation, big_sur:       "8f92b4d6c5f6b8e67a70384ec47550fbe421cefbc6b5a308a36350f17f798efe"
    sha256 cellar: :any_skip_relocation, catalina:      "003e71e052e20ad5ab951416aee18a722e2b613a0c5813199a03d80e531b12d2"
    sha256 cellar: :any_skip_relocation, mojave:        "d42f558cba47e63b7bc75ec85f6124baad63395ee46ce812bac635be4e64d1ad"
  end

  depends_on "ruby@2.7" if MacOS.version <= :mojave

  # All of these resources are for the asciidoctor-pdf, coderay and rouge gems. To update the asciidoctor-pdf
  # resources, check https://rubygems.org/gems/asciidoctor-pdf for the latest dependency versions. Make sure to select
  # the correct version of each dependency gem because the allowable versions can differ between versions.
  # To help, click on "Show all transitive dependencies" for a tree view of all dependencies. I've added comments
  # above each resource to make updating them easier, but please update those comments as the dependencies change.

  # asciidoctor-pdf requires concurrent-ruby ~> 1.1.0
  resource "concurrent-ruby" do
    url "https://rubygems.org/gems/concurrent-ruby-1.1.8.gem"
    sha256 "e35169e8e01c33cddc9d322e4e793a9bc8c3c00c967d206d17457e0d301f2257"
  end

  # prawn 2.2.0 requires pdf-core ~> 0.7.0
  resource "pdf-core" do
    url "https://rubygems.org/gems/pdf-core-0.7.0.gem"
    sha256 "c1afdbb79edaf7c9fea69fd4b8d3b2c68eeb7203ce4db0e80be5392e20e394a6"
  end

  # prawn 2.2.0 requires ttfunk ~> 1.5
  # asciidoctor-pdf requires ttfunk ~> 1.5.0, >= 1.5.1
  # pdf-reader requires ttfunk
  resource "ttfunk" do
    url "https://rubygems.org/downloads/ttfunk-1.5.1.gem"
    sha256 "8da1c20cc9e010a4b083376e6ae6996c4aa517558420bb23d9a1d8a228b6f9d5"
  end

  # asciidoctor-pdf requires prawn ~> 2.2.0
  # prawn-icon requires prawn >= 1.1.0, < 3.0.0
  # prawn-svg requires prawn >= 0.11.1, < 3
  # prawn-templates requires prawn ~> 2.2
  resource "prawn" do
    url "https://rubygems.org/gems/prawn-2.2.2.gem"
    sha256 "95284b761f0ea99334ef840ab85f577cfe2cc9448f769cc723843a6d7670b2e1"
  end

  # asciidoctor-pdf requires prawn-icon ~> 2.5.0
  resource "prawn-icon" do
    url "https://rubygems.org/gems/prawn-icon-2.5.0.gem"
    sha256 "dc88129676707c983e914ca2d2f066fb244e946075ed933c8422b996916b73c7"
  end

  # addressable requires public_suffix  >= 2.0.2, < 5.0
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
    url "https://rubygems.org/gems/css_parser-1.9.0.gem"
    sha256 "a19cbe6edf9913b596c63bc285681b24288820bbe32c51564e09b49e9a8d4477"
  end

  # asciidoctor-pdf requires prawn-svg ~> 0.31.0
  resource "prawn-svg" do
    url "https://rubygems.org/gems/prawn-svg-0.31.0.gem"
    sha256 "d40435a7880e76d7b6053c819c8033862ffa8c0fc5271ea9f11b1286658565e5"
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

  # asciidoctor-pdf requries thread_safe ~> 0.3.0
  resource "thread_safe" do
    url "https://rubygems.org/gems/thread_safe-0.3.6.gem"
    sha256 "9ed7072821b51c57e8d6b7011a8e282e25aeea3a4065eab326e43f66f063b05a"
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
    url "https://rubygems.org/gems/asciidoctor-pdf-1.5.4.gem"
    sha256 "c7a8998e905770628829972320017415174e69dea29fd0717e08e49d69b2104d"
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
