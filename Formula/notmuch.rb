class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org"
  url "https://notmuchmail.org/releases/notmuch-0.27.tar.gz"
  sha256 "40d3192f8f130f227b511fc80be86310c7f60ccb6d043b563f201fa505de0876"
  head "git://notmuchmail.org/git/notmuch"

  bottle do
    cellar :any
    rebuild 1
    sha256 "81d9986da9f924e96e01a5bac0aa7e17c817c09636d71142014c9f3829f708c9" => :mojave
    sha256 "369405e2329d4a7b2ba458523100a8f3983bfa0ade7409cd6eb0b6d58bedbc18" => :high_sierra
    sha256 "aa6bb5fe775c2034e5ababa0ca796853ad52e8e58328eef29fc728fc1b1ddc29" => :sierra
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
