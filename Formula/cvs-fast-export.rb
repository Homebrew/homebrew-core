class CvsFastExport < Formula
  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "http://www.catb.org/~esr/cvs-fast-export/cvs-fast-export-1.57.tar.gz"
  sha256 "284a09f29fe1e385930941a1369a5846609d8caec2d69b95b629a8c7a2fe2e78"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cvs-fast-export[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4f70453ca80136a9a69052148d93fa038907a10021ae8803502958bbb72a8e96"
    sha256 cellar: :any_skip_relocation, big_sur:       "71d68dd5f5f78951b3a8073145b95d11252553c0017c37790641b013cc987137"
    sha256 cellar: :any_skip_relocation, catalina:      "c0e9f0fae2e3d2059389bb41964939618b8a1447a682396700f18125c3e6bf78"
    sha256 cellar: :any_skip_relocation, mojave:        "b5da0899a17bde18f92dc8be26016fcc14a19da1c7f41fd09a8b70cf1a82dc2e"
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
