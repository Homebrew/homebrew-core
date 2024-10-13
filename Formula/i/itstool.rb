class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "https://itstool.org/"
  url "https://files.itstool.org/itstool/itstool-2.0.7.tar.bz2"
  sha256 "6b9a7cd29a12bb95598f5750e8763cee78836a1a207f85b74d8b3275b27e87ca"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "71c806c3d88f9f19ed3e561e48dac34aab652f2ebacd156f2ce8ccf9192b0f40"
  end

  head do
    url "https://github.com/itstool/itstool.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libxml2"
  depends_on "python@3.12"

  def install
    python3 = "python3.12"
    ENV.append_path "PYTHONPATH", Formula["libxml2"].opt_prefix/Language::Python.site_packages(python3)

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--prefix=#{libexec}", "PYTHON=#{which(python3)}"
    system "make", "install"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"]
    pkgshare.install_symlink libexec/"share/itstool/its"
    man1.install_symlink libexec/"share/man/man1/itstool.1"

    # Check for itstool data files in HOMEBREW_PREFIX. This also ensures uniform bottles.
    inreplace libexec/"bin/itstool", "/usr/local", HOMEBREW_PREFIX
  end

  test do
    (testpath/"test.xml").write <<~EOS
      <tag>Homebrew</tag>
    EOS
    system bin/"itstool", "-o", "test.pot", "test.xml"
    assert_match "msgid \"Homebrew\"", File.read("test.pot")
  end
end
