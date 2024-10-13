class CvsFastExport < Formula
  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "http://www.catb.org/~esr/cvs-fast-export/cvs-fast-export-1.68.tar.gz"
  sha256 "841c60d9af70ca260fec572f2ef08ed523314f6cacfda40bb44dacb9dbcda841"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cvs-fast-export[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f7b2c67fe9436b3cfc2d64706c46ed8913e75db0486e72527be0c200fd31fbf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dba6bf27f82465c252bd146ea828f2e93849c7886015a66a3359957be1a32ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5e0e6010700405c1ef04acc75e09e45b2e513dd884e85145cc0876de50b6f10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "034da199bcd8f5bef619c446d548727e6657dccdcda38933a23247c5cd476d0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6aca690bf14add0b2daa03afc21b4efdfe093770c8547eb17ee271aea9a32bc"
    sha256 cellar: :any_skip_relocation, ventura:        "b70d7f541af12e97ee607b9d7fa1665af6bbfd6051e31bb6b93b71c220fa115d"
    sha256 cellar: :any_skip_relocation, monterey:       "3dde4030da24cab974a110ff6954b9d5b01091f33f16d936cad581e8db55067b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9a04b0289478952e4f7991b95d9f0ced10fedc353c263e28924195dc60a1727"
  end

  head do
    url "https://gitlab.com/esr/cvs-fast-export.git", branch: "master"
    depends_on "bison" => :build
  end

  depends_on "asciidoctor" => :build
  depends_on "cvs" => :test

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

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
