class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "http://itstool.org/"
  url "https://github.com/itstool/itstool/archive/2.0.6.tar.gz"
  sha256 "bda0b08e9a1db885c9d7d1545535e9814dd8931d5b8dd5ab4a47bd769d0130c6"
  license "GPL-3.0"
  revision 1
  head "https://github.com/itstool/itstool.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "73238debce4f4c1e9922427a22312161d0400d70f22b642137689b4431ba0a20" => :catalina
    sha256 "73238debce4f4c1e9922427a22312161d0400d70f22b642137689b4431ba0a20" => :mojave
    sha256 "73238debce4f4c1e9922427a22312161d0400d70f22b642137689b4431ba0a20" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libxml2"
  depends_on "python@3.8"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python#{xy}/site-packages"

    system "./autogen.sh", "--prefix=#{libexec}",
                           "PYTHON=#{Formula["python@3.8"].opt_bin}/python3"
    system "make", "install"

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
    pkgshare.install_symlink libexec/"share/itstool/its"
    man1.install_symlink libexec/"share/man/man1/itstool.1"
  end

  test do
    (testpath/"test.xml").write <<~EOS
      <tag>Homebrew</tag>
    EOS
    system bin/"itstool", "-o", "test.pot", "test.xml"
    assert_match "msgid \"Homebrew\"", File.read("test.pot")
  end
end
