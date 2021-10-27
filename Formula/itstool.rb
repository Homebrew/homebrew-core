class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "http://itstool.org/"
  url "https://github.com/itstool/itstool/archive/2.0.7.tar.gz"
  sha256 "fba78a37dc3535e4686c7f57407b97d03c676e3a57beac5fb2315162b0cc3176"
  license "GPL-3.0"
  head "https://github.com/itstool/itstool.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01fcbe25d1551ec84a14e3a880d9565057065d5024491f870626e5d89921565d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01fcbe25d1551ec84a14e3a880d9565057065d5024491f870626e5d89921565d"
    sha256 cellar: :any_skip_relocation, monterey:       "acbdf687a02126c08c69514d248804c3833408331272fe8fb3751eb7d8dc0502"
    sha256 cellar: :any_skip_relocation, big_sur:        "acbdf687a02126c08c69514d248804c3833408331272fe8fb3751eb7d8dc0502"
    sha256 cellar: :any_skip_relocation, catalina:       "acbdf687a02126c08c69514d248804c3833408331272fe8fb3751eb7d8dc0502"
    sha256 cellar: :any_skip_relocation, mojave:         "acbdf687a02126c08c69514d248804c3833408331272fe8fb3751eb7d8dc0502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01fcbe25d1551ec84a14e3a880d9565057065d5024491f870626e5d89921565d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libxml2"
  depends_on "python@3.9"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python#{xy}/site-packages"

    system "./autogen.sh", "--prefix=#{libexec}",
                           "PYTHON=#{Formula["python@3.9"].opt_bin}/python3"
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
