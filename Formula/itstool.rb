class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "http://itstool.org/"
  url "http://files.itstool.org/itstool/itstool-2.0.7.tar.bz2"
  sha256 "6b9a7cd29a12bb95598f5750e8763cee78836a1a207f85b74d8b3275b27e87ca"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b9f7a4ddf5a15f67751b6dc0429dd9226f2b8c1bf81d13b5068c29fc1d7e65f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "108962bdce11e7b353a94f61ae30c82212295963d157cd667fb9af6069801cbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "108962bdce11e7b353a94f61ae30c82212295963d157cd667fb9af6069801cbd"
    sha256 cellar: :any_skip_relocation, ventura:        "fbfc77345dc63340e7bfed0340671d34e12ce8d388070bdc3e833816c6bf6df0"
    sha256 cellar: :any_skip_relocation, monterey:       "211f56048a0498fd935fac91466be64590276ae236d5a60be45ff2061713087f"
    sha256 cellar: :any_skip_relocation, big_sur:        "211f56048a0498fd935fac91466be64590276ae236d5a60be45ff2061713087f"
    sha256 cellar: :any_skip_relocation, catalina:       "211f56048a0498fd935fac91466be64590276ae236d5a60be45ff2061713087f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "108962bdce11e7b353a94f61ae30c82212295963d157cd667fb9af6069801cbd"
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
