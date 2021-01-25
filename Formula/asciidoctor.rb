class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https://asciidoctor.org/"
  url "https://github.com/asciidoctor/asciidoctor/archive/v2.0.12.tar.gz"
  sha256 "cd98047c68bf1074a7058b174c93a64f2bd39c2f33941398f6889c562ed5bce8"
  license "MIT"

  depends_on "ruby" if MacOS.version <= :sierra

  bottle do
    cellar :any_skip_relocation
    sha256 "4af4798f8081100713a1b3d301107b5ddd01d1f85d40d5f351d12b3261148fbe" => :big_sur
    sha256 "bd10fcb661d700a6dc30113b6af905708978ca6d4198ea6531abc80628a34f2a" => :arm64_big_sur
    sha256 "b6d75bed00d6ab5586634823bee006e5f0bb3c57f9f46317b675c33b28eb7552" => :catalina
    sha256 "8ce4eb3ad0b311775a31f15d32939df21f3eefbac6dc39ac76f2d2573920b5af" => :mojave
    sha256 "d4fa41fc1f142f4d8ad25c2063ed79dd04091386d87c7996c17c9adcb10be301" => :high_sierra
  end

  resource "concurrent-ruby" do
    url "https://rubygems.org/gems/concurrent-ruby-1.1.7.gem"
    sha256 "ff4befc88d522ccb2109596da26309f4b0b041683ca62d3cb903b313e1caddee"
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
    url "https://rubygems.org/gems/public_suffix-4.0.6.gem"
    sha256 "a99967c7b2d1d2eb00e1142e60de06a1a6471e82af574b330e9af375e87c0cf7"
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
    url "https://rubygems.org/gems/pdf-reader-2.4.1.gem"
    sha256 "705502cf151ac59a774a368819bd96c174bc63552cdc4a2f7db80ad0187d0725"
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
    url "https://rubygems.org/gems/asciidoctor-pdf-1.5.3.gem"
    sha256 "3e70d0e513f4d631a4b667fed634700d93b104e0d3b4c33f993979df6a67d3f1"
  end

  resource "coderay" do
    url "https://rubygems.org/gems/coderay-1.1.3.gem"
    sha256 "dc530018a4684512f8f38143cd2a096c9f02a1fc2459edcfe534787a7fc77d4b"
  end

  resource "rouge" do
    url "https://rubygems.org/gems/rouge-3.24.0.gem"
    sha256 "228df3eae97599f49546b2b34ffba34bff86a9f3a712327b27586d301f00f4c5"
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
