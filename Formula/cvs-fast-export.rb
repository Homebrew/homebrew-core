class CvsFastExport < Formula
  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "http://www.catb.org/~esr/cvs-fast-export/cvs-fast-export-1.58.tar.gz"
  sha256 "8d8fc65116ba5b350bc299e8a819b355074ae161fde6d7f9f6fd3bcbc8077963"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cvs-fast-export[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "66ac0fb37d3e4a33d2a1cf562d2297a36373a8017e0850f9cf1c3c4218c3f414"
    sha256 cellar: :any_skip_relocation, big_sur:       "2e22e212cd8aac46d6e4aad35afe9bc45fa79ac81f67b12bad4442f2adb0e691"
    sha256 cellar: :any_skip_relocation, catalina:      "ffefb6abe0cc10db5a854cb25b51bec3b0506327695d69572d8e5c303272c182"
    sha256 cellar: :any_skip_relocation, mojave:        "81d7a4592179d55d6e0a223c5678573e3fbdf53eb656f9be5537597c94d1c304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "265a49c7aff2adf6cdaa534786bfd68281a9bdf9d924721aa70244b13868154b"
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
