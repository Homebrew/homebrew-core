class CvsFastExport < Formula
  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "http://www.catb.org/~esr/cvs-fast-export/cvs-fast-export-1.59.tar.gz"
  sha256 "2439cd83f54c98f248e85d3ba3becbe028580e89652c50756022fbe564a9e8da"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cvs-fast-export[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5e761e7cd008d32d3635bbd954ce0319a125a278e89df39ba0283b163c2310e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f67f51244e6191a06fad37c03c8f0c19586c2f31a2b3142e547aa1520808ceb"
    sha256 cellar: :any_skip_relocation, monterey:       "12792207ac5289b70caab3f356d05ac3885286d152a26746ff99474130203228"
    sha256 cellar: :any_skip_relocation, big_sur:        "677fd2515d4ba02e87130f58ac3414ce4f2cb55c91ca024365cbfc2d552a421c"
    sha256 cellar: :any_skip_relocation, catalina:       "247aed80d2a7ae72a264aebaa9e52901bb23be829645826a026f236ace7fc2e0"
    sha256 cellar: :any_skip_relocation, mojave:         "baf10f703b56df5adb4e41f60ac5a5c90734b446c0003f49494e983e49229739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90ea42813a02d6faaf251b749efa907c5ac0a6c3ebfd5fafafa0d49e584ae3ca"
  end

  head do
    url "https://gitlab.com/esr/cvs-fast-export.git"
    depends_on "bison" => :build
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "cvs" => :test

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

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
