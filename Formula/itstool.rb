class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "http://itstool.org/"
  url "https://github.com/itstool/itstool/archive/2.0.7.tar.gz"
  sha256 "fba78a37dc3535e4686c7f57407b97d03c676e3a57beac5fb2315162b0cc3176"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/itstool/itstool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "108962bdce11e7b353a94f61ae30c82212295963d157cd667fb9af6069801cbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "108962bdce11e7b353a94f61ae30c82212295963d157cd667fb9af6069801cbd"
    sha256 cellar: :any_skip_relocation, monterey:       "211f56048a0498fd935fac91466be64590276ae236d5a60be45ff2061713087f"
    sha256 cellar: :any_skip_relocation, big_sur:        "211f56048a0498fd935fac91466be64590276ae236d5a60be45ff2061713087f"
    sha256 cellar: :any_skip_relocation, catalina:       "211f56048a0498fd935fac91466be64590276ae236d5a60be45ff2061713087f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "108962bdce11e7b353a94f61ae30c82212295963d157cd667fb9af6069801cbd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libxml2"
  depends_on "python@3.10"

  def install
    python3 = "python3.10"
    ENV.append_path "PYTHONPATH", Formula["libxml2"].opt_prefix/Language::Python.site_packages(python3)

    system "./autogen.sh", "--prefix=#{libexec}", "PYTHON=#{which(python3)}"
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
