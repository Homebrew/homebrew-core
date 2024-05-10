class CvsFastExport < Formula
  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "http://www.catb.org/~esr/cvs-fast-export/cvs-fast-export-1.66.tar.gz"
  sha256 "e44c347846bacaade787d6daf531bca7932d3316e1274e02f815bd9a5a5ffbbf"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cvs-fast-export[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b6c2d05c8c3b22e47ed5f1c368b7381d5a2a76f1cd2c5d5f098645ec17fa7f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e0f6aeab68b391cc908876e0357057ef922a78a6835e32157450f2f035c48c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13d158f6cca486604c0e7a5afe99862cc4d4cec9ec5f12c6c3dbe49faf1d4ed5"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2017f32045e4162de119afa4d82fbd4ced0432c04b0eb85e8de5fbf8b5b68d0"
    sha256 cellar: :any_skip_relocation, ventura:        "51484b2b98aca361686a88e9501f1d9692fd913dda24f22bb44b2a33197edbe5"
    sha256 cellar: :any_skip_relocation, monterey:       "8671a866a3d0e4aff05b4ff6aff5c294ed5a7dc415503e1897bad31aa5aee0dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c7bea7a29f8ed65bf34ff06479de4eb2d21ea481b043580c1dd0fa3dec5d5f3"
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
