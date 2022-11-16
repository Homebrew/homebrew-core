class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "http://itstool.org/"
  url "http://files.itstool.org/itstool/itstool-2.0.7.tar.bz2"
  sha256 "6b9a7cd29a12bb95598f5750e8763cee78836a1a207f85b74d8b3275b27e87ca"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63d15cf95366fdd8d62b26b7105d8c097d9c715ac080d04118ba5c8eba8c4690"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63d15cf95366fdd8d62b26b7105d8c097d9c715ac080d04118ba5c8eba8c4690"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63d15cf95366fdd8d62b26b7105d8c097d9c715ac080d04118ba5c8eba8c4690"
    sha256 cellar: :any_skip_relocation, ventura:        "d7df12dd9d64c70c59da80ea8e65bdc10a2cb3f74e5cd701a48f9958c62def29"
    sha256 cellar: :any_skip_relocation, monterey:       "d7df12dd9d64c70c59da80ea8e65bdc10a2cb3f74e5cd701a48f9958c62def29"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7df12dd9d64c70c59da80ea8e65bdc10a2cb3f74e5cd701a48f9958c62def29"
    sha256 cellar: :any_skip_relocation, catalina:       "d7df12dd9d64c70c59da80ea8e65bdc10a2cb3f74e5cd701a48f9958c62def29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63d15cf95366fdd8d62b26b7105d8c097d9c715ac080d04118ba5c8eba8c4690"
  end

  head do
    url "https://github.com/itstool/itstool.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libxml2"
  depends_on "python@3.11"

  def install
    python3 = "python3.11"
    ENV.append_path "PYTHONPATH", Formula["libxml2"].opt_prefix/Language::Python.site_packages(python3)

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--prefix=#{libexec}", "PYTHON=#{which(python3)}"
    system "make", "install"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"]
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
