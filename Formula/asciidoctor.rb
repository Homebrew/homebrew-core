class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v2.0.13.tar.gz"
  sha256 "4812dd15bb71b3ae8351e8e3c2df4528c7c40dd97ef1954a56442b56b59019a6"
  license "MIT"

  depends_on "ruby" if MacOS.version <= :sierra

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bd10fcb661d700a6dc30113b6af905708978ca6d4198ea6531abc80628a34f2a"
    sha256 cellar: :any_skip_relocation, big_sur:       "4af4798f8081100713a1b3d301107b5ddd01d1f85d40d5f351d12b3261148fbe"
    sha256 cellar: :any_skip_relocation, catalina:      "b6d75bed00d6ab5586634823bee006e5f0bb3c57f9f46317b675c33b28eb7552"
    sha256 cellar: :any_skip_relocation, mojave:        "8ce4eb3ad0b311775a31f15d32939df21f3eefbac6dc39ac76f2d2573920b5af"
    sha256 cellar: :any_skip_relocation, high_sierra:   "d4fa41fc1f142f4d8ad25c2063ed79dd04091386d87c7996c17c9adcb10be301"
  end

  resource "concurrent-ruby" do
    url "https://rubygems.org/gems/concurrent-ruby-1.1.8.gem"
    sha256 "e35169e8e01c33cddc9d322e4e793a9bc8c3c00c967d206d17457e0d301f2257"
  end

  resource "pdf-core" do
    url "https://rubygems.org/gems/pdf-core-0.9.0.gem"
    sha256 "4f368b2f12b57ec979872d4bf4bd1a67e8648e0c81ab89801431d2fc89f4e0bb"
  end

  resource "ttfunk" do
    url "https://rubygems.org/downloads/ttfunk-1.7.0.gem"
    sha256 "2370ba484b1891c70bdcafd3448cfd82a32dd794802d81d720a64c15d3ef2a96"
  end

  resource "prawn" do
    url "https://rubygems.org/gems/prawn-2.4.0.gem"
    sha256 "82062744f7126c2d77501da253a154271790254dfa8c309b8e52e79bc5de2abd"
  end

  resource "prawn-icon" do
    url "https://rubygems.org/gems/prawn-icon-3.0.0.gem"
    sha256 "dac8d481dee0f60a769c0cab0fd1baec7351b4806bf9ba959cd6c65f6694b6f5"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-4.0.6.gem"
    sha256 "a99967c7b2d1d2eb00e1142e60de06a1a6471e82af574b330e9af375e87c0cf7"
  end

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.7.0.gem"
    sha256 "5e9b62fe1239091ea9b2893cd00ffe1bcbdd9371f4e1d35fac595c98c5856cbb"
  end

  resource "css_parser" do
    url "https://rubygems.org/gems/css_parser-1.9.0.gem"
    sha256 "a19cbe6edf9913b596c63bc285681b24288820bbe32c51564e09b49e9a8d4477"
  end

  resource "prawn-svg" do
    url "https://rubygems.org/gems/prawn-svg-0.32.0.gem"
    sha256 "66d1a20a93282528a25d5ad9e0db422dad4804a34e0892561b64c3930fff7d55"
  end

  resource "prawn-table" do
    url "https://rubygems.org/gems/prawn-table-0.2.2.gem"
    sha256 "336d46e39e003f77bf973337a958af6a68300b941c85cb22288872dc2b36addb"
  end

  resource "afm" do
    url "https://rubygems.org/gems/afm-0.2.2.gem"
    sha256 "c83e698e759ab0063331ff84ca39c4673b03318f4ddcbe8e90177dd01e4c721a"
  end

  resource "Ascii85" do
    url "https://rubygems.org/gems/Ascii85-1.1.0.gem"
    sha256 "9ce694467bd69ab2349768afd27c52ad721cdc6f642aeaa895717bfd7ada44b7"
  end

  resource "hashery" do
    url "https://rubygems.org/gems/hashery-2.1.2.gem"
    sha256 "d239cc2310401903f6b79d458c2bbef5bf74c46f3f974ae9c1061fb74a404862"
  end

  resource "ruby-rc4" do
    url "https://rubygems.org/gems/ruby-rc4-0.1.5.gem"
    sha256 "00cc40a39d20b53f5459e7ea006a92cf584e9bc275e2a6f7aa1515510e896c03"
  end

  resource "pdf-reader" do
    url "https://rubygems.org/gems/pdf-reader-2.4.2.gem"
    sha256 "26a27981377a856ccbcaddc5c3001eab7b887066c388351499b0a1e07b53b4b3"
  end

  resource "prawn-templates" do
    url "https://rubygems.org/gems/prawn-templates-0.1.2.gem"
    sha256 "117aa03db570147cb86fcd7de4fd896994f702eada1d699848a9529a87cd31f1"
  end

  resource "safe_yaml" do
    url "https://rubygems.org/gems/safe_yaml-1.0.5.gem"
    sha256 "a6ac2d64b7eb027bdeeca1851fe7e7af0d668e133e8a88066a0c6f7087d9f848"
  end

  resource "thread_safe" do
    url "https://rubygems.org/gems/thread_safe-0.3.6.gem"
    sha256 "9ed7072821b51c57e8d6b7011a8e282e25aeea3a4065eab326e43f66f063b05a"
  end

  resource "polyglot" do
    url "https://rubygems.org/gems/polyglot-0.3.5.gem"
    sha256 "59d66ef5e3c166431c39cb8b7c1d02af419051352f27912f6a43981b3def16af"
  end

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
      r.fetch
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
    (testpath/"test.adoc").write <<~EOS
      = AsciiDoc is Writing Zen
      Random J. Author <rjauthor@example.com>
      :icons: font

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
    system bin/"asciidoctor", "-b", "html5", "-o", "test.html", "test.adoc"
    assert_match "<h1>AsciiDoc is Writing Zen</h1>", File.read("test.html")
    system bin/"asciidoctor", "-r", "asciidoctor-pdf", "-b", "pdf", "-o", "test.pdf", "test.adoc"
    assert_match "/Title (AsciiDoc is Writing Zen)", File.read("test.pdf", mode: "rb")
  end
end
