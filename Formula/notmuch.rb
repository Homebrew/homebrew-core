class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.28.4.tar.gz"
  sha256 "bab1cabb0542ce2bd4b41a15b84a8d81c8dc3332162705ded6f311dd898656ca"
  head "https://git.notmuchmail.org/git/notmuch", :using => :git

  bottle do
    cellar :any
    sha256 "7a28cc4dc79666ee4a026d7b14cbf1f4ecfd533beca9b74f41b00bf83fb281a4" => :mojave
    sha256 "f47dc47e3cb0dccc48ad57e07bafbe7303189f98fe4f772fd7c1684cc71ac978" => :high_sierra
    sha256 "0c1426a919d84933ea3d0c95466bf7119eb42a1c1e4485bb76de05d63c675f2f" => :sierra
  end

  depends_on "doxygen" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "emacs"
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@2"
  depends_on "talloc"
  depends_on "xapian"
  depends_on "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-emacs
      --emacslispdir=#{elisp}
      --emacsetcdir=#{elisp}
      --without-ruby
    ]

    # Emacs and parallel builds aren't friends
    ENV.deparallelize

    system "./configure", *args
    system "make", "V=1", "install"

    cd "bindings/python" do
      system "python2.7", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    (testpath/".notmuch-config").write "[database]\npath=#{testpath}/Mail"
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")
  end
end
