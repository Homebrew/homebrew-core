class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "https://itstool.org/"
  url "https://files.itstool.org/itstool/itstool-2.0.7.tar.bz2"
  sha256 "6b9a7cd29a12bb95598f5750e8763cee78836a1a207f85b74d8b3275b27e87ca"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca64b6795a975cff894c9f7a7d83f350155b69b361fb8992468faddde193ad5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca64b6795a975cff894c9f7a7d83f350155b69b361fb8992468faddde193ad5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca64b6795a975cff894c9f7a7d83f350155b69b361fb8992468faddde193ad5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "74c85e558123ab5ff7b98d87b40909c1455785ad91a8b25d56090be6a8e36ddc"
    sha256 cellar: :any_skip_relocation, ventura:        "74c85e558123ab5ff7b98d87b40909c1455785ad91a8b25d56090be6a8e36ddc"
    sha256 cellar: :any_skip_relocation, monterey:       "74c85e558123ab5ff7b98d87b40909c1455785ad91a8b25d56090be6a8e36ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca64b6795a975cff894c9f7a7d83f350155b69b361fb8992468faddde193ad5d"
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
  end

  test do
    (testpath/"test.xml").write <<~EOS
      <tag>Homebrew</tag>
    EOS
    system bin/"itstool", "-o", "test.pot", "test.xml"
    assert_match "msgid \"Homebrew\"", File.read("test.pot")
  end
end
