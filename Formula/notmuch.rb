class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.30.tar.xz"
  sha256 "5e3baa6fe11d65c67e26ae488be11b320bae04e336acc9c64621f7e3449096fa"
  head "https://git.notmuchmail.org/git/notmuch", using: :git

  bottle do
    cellar :any
    sha256 "5a49517024f99e8c7a76cacf5a3ea51f1c565aa3fa97cd1844345431173aa009" => :catalina
    sha256 "82ea94e5bd97640dc1b5fe8aacf69f2a2bfce2127d76551e6344961ca698ebdb" => :mojave
    sha256 "680188d9c38ceb1f571ec4166d9d47b558797fac156de1f89f6296c469bb1311" => :high_sierra
  end

  depends_on "doxygen" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@3.8"
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

    ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/"lib/python3.8/site-packages"

    system "./configure", *args
    system "make", "V=1", "install"

    bash_completion.install "completion/notmuch-completion.bash"

    (prefix/"vim/plugin").install "vim/notmuch.vim"
    (prefix/"vim/doc").install "vim/notmuch.txt"
    (prefix/"vim").install "vim/syntax"

    cd "bindings/python" do
      system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    (testpath/".notmuch-config").write "[database]\npath=#{testpath}/Mail"
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")
  end
end
