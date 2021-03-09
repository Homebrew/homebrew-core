class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.31.4.tar.xz"
  sha256 "8661b66567660fd630af10c4647c30327fdd1b34a988cab80d614328a5b74f55"
  license "GPL-3.0-or-later"
  revision 1
  head "https://git.notmuchmail.org/git/notmuch", using: :git

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c042906e75dcade6c9e501bf603bf60847a90bd3535497c3b3259d03932ddf9b"
    sha256 cellar: :any, big_sur:       "5d5781026437ce04c590ae46dab93e1adecff5fcd6a40f821fe7119de69f14d0"
    sha256 cellar: :any, catalina:      "223395abe26a26918e7f8b1893fa666e417b20d30ba3c8e4035755d0ce870754"
    sha256 cellar: :any, mojave:        "be5af71fc297f08ada237d27f4bbb60c5ace573e6656a1f64c603839301caf72"
  end

  depends_on "doxygen" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@3.9"
  depends_on "talloc"
  depends_on "xapian"

  uses_from_macos "zlib", since: :sierra

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --emacslispdir=#{elisp}
      --emacsetcdir=#{elisp}
      --bashcompletiondir=#{bash_completion}
      --zshcompletiondir=#{zsh_completion}
      --without-ruby
    ]

    ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/"lib/python3.9/site-packages"

    system "./configure", *args
    system "make", "V=1", "install"

    bash_completion.install "completion/notmuch-completion.bash"

    (prefix/"vim/plugin").install "vim/notmuch.vim"
    (prefix/"vim/doc").install "vim/notmuch.txt"
    (prefix/"vim").install "vim/syntax"

    cd "bindings/python" do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    (testpath/".notmuch-config").write "[database]\npath=#{testpath}/Mail"
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")
  end
end
