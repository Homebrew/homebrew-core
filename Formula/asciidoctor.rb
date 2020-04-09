class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v2.0.10.tar.gz"
  sha256 "afca74837e6d4b339535e8ba0b79f2ad00bd1eef78bf391cc36995ca2e31630a"
  revision 1

  depends_on "ruby" if MacOS.version <= :sierra

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "db4b7fcb39a5d783d294f01094becbd6ff7fab7f258661eb1f2e8be2b8efb5bc" => :catalina
    sha256 "666df89ed2734108ca6d60ea66780e3fc3cc79bc03924f33e45c33c3f73ebe17" => :mojave
    sha256 "1d16ba582ee12787f64ed619600f911cc545ce931c9862f52adb48ec110e9505" => :high_sierra
  end

  resource "concurrent-ruby" do
    url "https://rubygems.org/gems/concurrent-ruby-1.1.6.gem"
    sha256 "14da21d5cfe9ccb02e9359b01cb7291e0167ded0ec805d4f3a4b2b4ffa418324"
  end

  resource "pdf-core" do
    url "https://rubygems.org/gems/pdf-core-0.7.0.gem"
    sha256 "c1afdbb79edaf7c9fea69fd4b8d3b2c68eeb7203ce4db0e80be5392e20e394a6"
  end

  resource "ttfunk" do
    url "https://rubygems.org/downloads/ttfunk-1.5.1.gem"
    sha256 "8da1c20cc9e010a4b083376e6ae6996c4aa517558420bb23d9a1d8a228b6f9d5"
  end

  resource "prawn" do
    url "https://rubygems.org/gems/prawn-2.2.2.gem"
    sha256 "95284b761f0ea99334ef840ab85f577cfe2cc9448f769cc723843a6d7670b2e1"
  end

  resource "prawn-icon" do
    url "https://rubygems.org/gems/prawn-icon-2.5.0.gem"
    sha256 "dc88129676707c983e914ca2d2f066fb244e946075ed933c8422b996916b73c7"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-4.0.3.gem"
    sha256 "87a9b64575e6d04a2e83882a2610470ea47132828c96650610b4c511b4c1d3b0"
  end

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.7.0.gem"
    sha256 "5e9b62fe1239091ea9b2893cd00ffe1bcbdd9371f4e1d35fac595c98c5856cbb"
  end

  resource "css_parser" do
    url "https://rubygems.org/gems/css_parser-1.7.1.gem"
    sha256 "dc35cf9ea61daac68007b0ffb0d84fd3159013f546e13441c93297ca106d8411"
  end

  resource "prawn-svg" do
    url "https://rubygems.org/gems/prawn-svg-0.30.0.gem"
    sha256 "e7d85c2b7c05427cfe9860c29db99ce9c935bd88158eb340e4b70fcf12a1c335"
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
    url "https://rubygems.org/gems/Ascii85-1.0.3.gem"
    sha256 "7ae3f2eb83ef5962016802caf0ce7db500c1cc25f385877f6ec64a29cfa8a818"
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
    url "https://rubygems.org/gems/pdf-reader-2.4.0.gem"
    sha256 "de3968992d64c3fefe4e3976191cb4ab6d8a07e6926c67b684e50843aac86fbc"
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
    url "https://rubygems.org/gems/treetop-1.6.10.gem"
    sha256 "67df9f52c5fdeb7b2b8ce42156f9d019c1c4eb643481a68149ff6c0b65bc613c"
  end

  resource "asciidoctor-pdf" do
    url "https://rubygems.org/gems/asciidoctor-pdf-1.5.3.gem"
    sha256 "3e70d0e513f4d631a4b667fed634700d93b104e0d3b4c33f993979df6a67d3f1"
  end

  resource "coderay" do
    url "https://rubygems.org/gems/coderay-1.1.2.gem"
    sha256 "9efc1b3663fa561ccffada890bd1eec3a5466808ebc711ab1c5d300617d96a97"
  end

  resource "rouge" do
    url "https://rubygems.org/gems/rouge-3.17.0.gem"
    sha256 "f98a2702deb1110a3603f9ff06e948ce1b348972965478f529d718a76e998776"
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
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
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
    assert_match "/Title (AsciiDoc is Writing Zen)", File.read("test.pdf", :mode => "rb")
  end
end
