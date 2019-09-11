class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.29.1.tar.xz"
  sha256 "9846fc8e32d415cee41f6644581a4de7b0d2e6bc98e1ba86db918f061fcfe365"
  head "https://git.notmuchmail.org/git/notmuch", :using => :git

  bottle do
    cellar :any
    sha256 "1d456d008be57a9c621467edfa2ba9d7ce376f2ea26cd2892309c1fb127fe602" => :mojave
    sha256 "4d1b00b5f7751b2ecdd5b9d5db5c5638fcd3cd21ed03d18dd150f703c53b3392" => :high_sierra
    sha256 "7474e52c2648d5cb1499edb6980f3caa0d5e7274d2e32574512ab95ce7eb225e" => :sierra
  end

  depends_on "doxygen" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "emacs"
  depends_on "glib"
  depends_on "gmime"
  depends_on "python"
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
      system "python3", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    (testpath/".notmuch-config").write "[database]\npath=#{testpath}/Mail"
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")
  end
end
