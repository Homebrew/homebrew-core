class CvsFastExport < Formula
  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "http://www.catb.org/~esr/cvs-fast-export/cvs-fast-export-1.55.tar.gz"
  sha256 "af58e16667c6e02e8431ff666effe306d3b30086fab483170257890da1afc21b"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cvs-fast-export[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "af7e3b2fa6fd3c2e4095364bbf13af5e1aa9c00f7ff066f95f2b8485ce4b22b5" => :big_sur
    sha256 "57328518c731d726a7c7f4d1af902638c042711e79f73e34002d71f08a70d432" => :catalina
    sha256 "70e1bc966678021164929473ca45b68b3fc3a1daa94646ab75c1e24d409ab4d6" => :mojave
    sha256 "b95ad7499c774198531e33bbfc0dc6872af239d17e40a9e9fbf7102de8fdb067" => :high_sierra
  end

  head do
    url "https://gitlab.com/esr/cvs-fast-export.git"
    depends_on "bison" => :build
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "cvs" => :test

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

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
