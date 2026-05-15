class Paperjam < Formula
  desc "Program for transforming PDF files"
  homepage "https://mj.ucw.cz/sw/paperjam/"
  url "https://mj.ucw.cz/download/linux/paperjam-1.2.2.tar.gz"
  sha256 "a281912d00a935f490ce20873e87b82d5203bb6180326be1bec60184acab30fc"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?paperjam[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09f4e84aa79cc854def0e6175e28b4309108b31a1ba33e98546ae43f347d9412"
    sha256 cellar: :any,                 arm64_sequoia: "a7c254e007515ca0b2ba42063d766f12d5bc8521ce50b2019f71f7bf76920944"
    sha256 cellar: :any,                 arm64_sonoma:  "201983b5c3c8b90a58e66d5f43cec89005935277f3b0113c9c51692f486c00d0"
    sha256 cellar: :any,                 arm64_ventura: "6698810703ff9e4622a05bb1ddeb3428827199a2165869fb53736b088fcbaf79"
    sha256 cellar: :any,                 sonoma:        "91fa2261cd3db2b3224ec207ec99541cac0ea6aea77bb544362f288e731f8135"
    sha256 cellar: :any,                 ventura:       "53a29eb850b492e5aaffb84038267c8b23cca0c2569460568739f83553c47e25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7c6806d04b52f70dfae2d5e3f7b4c1041ab6d18a0753cc3907eb20a487fbb9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69fa71726997dffe37df6cad5c7ca2a9c0663bacb2ef40575b5e6751c79c72bb"
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libpaper"
  depends_on "qpdf"

  uses_from_macos "libxslt"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append "LDLIBS", "-liconv" if OS.mac?
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"paperjam", "modulo(2) { 1, 2: rotate(180) }", test_fixtures("test.pdf"), "output.pdf"
    assert_path_exists testpath/"output.pdf"
  end
end
