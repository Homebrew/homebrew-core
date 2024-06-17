class CvsFastExport < Formula
  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "http://www.catb.org/~esr/cvs-fast-export/cvs-fast-export-1.67.tar.gz"
  sha256 "2243af947d25a92728e0209739c2caa2bf920ceea311e9772ecd87c8b12910d4"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cvs-fast-export[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d3d255c5ab9de7b65fea425b22bf0bc8102935cd905f4be7d45927fc34780af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ba540052ec05dd12bd9cea9ed75b47b714457068335d1161f69980cc210938a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "380bce79e0b1a964eb028374fea9df54b2d2dfdd962587a1e07b956cfce254cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a05c4fd0449bbe508b8dee0cfc0ca0d0c173178eb959850e9538f5eb0ce10fb"
    sha256 cellar: :any_skip_relocation, ventura:        "ad9bac97125e7afdf8030b12639b0cac946e0f3c175d299579891cf4ad61bc1a"
    sha256 cellar: :any_skip_relocation, monterey:       "2fedd03dab581bd21bc93d17293e6076a8bd5f82d15004dc40892ba5be5eed0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eae09ed8af47ed4265fedf0f1dd6ef1151fda9a40e4a02bb3644edf983d4c059"
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
