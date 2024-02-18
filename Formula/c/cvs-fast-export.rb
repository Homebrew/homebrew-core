class CvsFastExport < Formula
  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "http://www.catb.org/~esr/cvs-fast-export/cvs-fast-export-1.65.tar.gz"
  sha256 "8823fb754cbda77eaa60294f531231216c9ccb536440cc459cbeb00f18c8774c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cvs-fast-export[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61aa603831163d746ed4a9ff686f21360df25a59969a81e0b3aa6dba0f0704b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d59ad0131f825381e336c604f14af6c32efc891cbd89d1ac96fd7888aa98cd99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e556b0702bbf5419e63520df4691a08921b97c717468ca02f34237cad45837b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5fe2f1ebb0a9f7f2a74974504547aab6508a03e2d29d23f26777c9d663fbe96"
    sha256 cellar: :any_skip_relocation, ventura:        "ce6216e0fba75052891c5f93237ad69ad0b91e25c67024be0b9cd53c48606af0"
    sha256 cellar: :any_skip_relocation, monterey:       "668cc6bf906a4acf98df2db9bde7032e04fa4b544508e6cc75932afce1e28c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96870466f03058622e4a3d688075e5d0cddc147fe0d61fb8c4d35aa226fc97ea"
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
