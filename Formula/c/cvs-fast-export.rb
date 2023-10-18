class CvsFastExport < Formula
  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "http://www.catb.org/~esr/cvs-fast-export/cvs-fast-export-1.61.tar.gz"
  sha256 "e221fc54ac559625592b0678d2b18c6f77c7d67c5305d313e48701cdda759a3c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cvs-fast-export[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1299b8af0d24783c8a2c6b8ef91459766ac5366e253772ecd5d99b29adf2f21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c50ee95a291372ba86ae9b699be52eb05021d07e94879d706aa5d62ca836d9c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80124aa55bd3aa14da8072520df95e8653f1a93ace0253a5c3b9770d1554d4e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0ea9df44b6032934177f2257d8ef4e237351a9ea40c80caaf53d12223dca662"
    sha256 cellar: :any_skip_relocation, sonoma:         "a26519a709ecc1d9b545ed74c75e64b5c1929cc502d04fba0b0616c1c53317b4"
    sha256 cellar: :any_skip_relocation, ventura:        "324a3468d896d92df266477b24394a52562199e76373f989b91e5dd9ec07b9c7"
    sha256 cellar: :any_skip_relocation, monterey:       "18ce15d7e398b6bd8634dcc4eb74b13aef8e18409759a5bca413e429bda2bb7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1103ec399ffbfbed891e202e726a2a08ecd95acd75578b42ce6b4d8850931309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "337b2c77ae1298e449fdab4050a5cefd5b774f3f214da1110010100d410efb54"
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
