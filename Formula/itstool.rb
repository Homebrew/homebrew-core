class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "http://itstool.org/"
  url "https://github.com/itstool/itstool/archive/2.0.5.tar.gz"
  sha256 "97f98e1a5f8f49239e4256570ecfe12caf88b7cfdb4fcb40f4b761ce7ea2a8c3"
  head "https://github.com/itstool/itstool.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c902eb9a16def09fbec97acf49178f7f048c27e1e6f25c8e8f6506d3b8ba9bd8" => :mojave
    sha256 "9dc3edc35150bd1701f9107b2248a5b275d1842447aa58f77341c4af8e478d7e" => :high_sierra
    sha256 "9dc3edc35150bd1701f9107b2248a5b275d1842447aa58f77341c4af8e478d7e" => :sierra
    sha256 "9dc3edc35150bd1701f9107b2248a5b275d1842447aa58f77341c4af8e478d7e" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libxml2"
  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python#{xy}/site-packages"

    system "./autogen.sh", "--prefix=#{libexec}",
                           "PYTHON=#{Formula["python"].opt_bin}/python3"
    system "make", "install"

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
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
