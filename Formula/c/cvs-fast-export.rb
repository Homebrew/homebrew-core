class CvsFastExport < Formula
  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "http://www.catb.org/~esr/cvs-fast-export/cvs-fast-export-1.60.tar.gz"
  sha256 "40b301617da7dbbadc69af548acaebd9522d82d4cfbf96566ce739b4ad5517cc"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cvs-fast-export[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b8d0dbd7a85889d3ca299b2b098c3a4e08569f97e397ed2d2baba4eff2b5c7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fec5ccf5b4aa1884860c7edf02e6cae2a22b000f8867583dc6905327dab2ccb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d7eae20d8cbf1ddd0b7a74baeb95c82fb12859ac363ed2b310a7e13ae9ca908"
    sha256 cellar: :any_skip_relocation, ventura:        "2754cf0b2a42e0b97d66de41e215df7071cbde53f9b834ac9a551a4909762589"
    sha256 cellar: :any_skip_relocation, monterey:       "3126ed9071ab791e7c8f2ca7d1782af00253fa3642d91a5846c581fa15a85dc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "800f1507561fd1610bd960ced127820426d0df18a070fa70a8653b4b7e137e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac1b6314630fe4c565e5091890266b2b28714d2c5e5ad1f879a7c8c6bacfb6a0"
  end

  head do
    url "https://gitlab.com/esr/cvs-fast-export.git", branch: "master"
    depends_on "bison" => :build
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "cvs" => :test

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Workaround for Xcode 14.3.
    ENV.append_to_cflags "-Wno-implicit-function-declaration"

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    cvsroot = testpath/"cvsroot"
    cvsroot.mkpath
    system "cvs", "-d", cvsroot, "init"

    test_content = "John Barleycorn"

    mkdir "cvsexample" do
      (testpath/"cvsexample/testfile").write(test_content)
      ENV["CVSROOT"] = cvsroot
      system "cvs", "import", "-m", "example import", "cvsexample", "homebrew", "start"
    end

    assert_match test_content, shell_output("find #{testpath}/cvsroot | #{bin}/cvs-fast-export")
  end
end
