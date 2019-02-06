class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "http://itstool.org/"
  url "https://github.com/itstool/itstool/archive/2.0.5.tar.gz"
  sha256 "97f98e1a5f8f49239e4256570ecfe12caf88b7cfdb4fcb40f4b761ce7ea2a8c3"
  head "https://github.com/itstool/itstool.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "efedec3984116c3e50e6bf3c7a30b6ccb392e0223934cd1e4081056191c619f5" => :mojave
    sha256 "7dc6c74dcdeb516071721537ec8b19ab3be9c44c6c77e86d6d841388a9dc95d1" => :high_sierra
    sha256 "7dc6c74dcdeb516071721537ec8b19ab3be9c44c6c77e86d6d841388a9dc95d1" => :sierra
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
