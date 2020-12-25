class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.31.3.tar.xz"
  sha256 "484041aed08f88f3a528a5b82489b6cda4090764228813bca73678da3a753aca"
  license "GPL-3.0-or-later"
  head "https://git.notmuchmail.org/git/notmuch", using: :git

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "86205549d8971bcc17798ef64d43853a96c180f1997e6d991ad106c654f00eb3" => :big_sur
    sha256 "77831c5c770e9a68678e822b2959c76724e44f3b6215f5b31f5293f68ac05c42" => :arm64_big_sur
    sha256 "33019e1569b78dc2ac4f72f6f901b05526d4678a2310f931609943f0f578c22b" => :catalina
    sha256 "feef25a27ef288c9506b51b1c3f5482ccf29b98e4341f89bdeccb4452d8fd07b" => :mojave
    sha256 "650579d43babe2435ba190a8cce066f1a3f6621ba840d7ea9a961b0f084ae589" => :high_sierra
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
  depends_on "zlib"

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
