class Notmuch < Formula
  include Language::Python::Shebang

  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.39.tar.xz"
  sha256 "b88bb02a76c46bad8d313fd2bb4f8e39298b51f66fcbeb304d9f80c3eef704e3"
  license "GPL-3.0-or-later"
  revision 1
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9fee07b53a4c07c793f00b7b7f516bbf2ad67f8a67cf6e015b2df4063ba4241a"
    sha256 cellar: :any,                 arm64_sequoia: "5d75485c3ae6dc4609f63d37a5f577325a6477f37bc65cb2be59603e85928692"
    sha256 cellar: :any,                 arm64_sonoma:  "54e6b5061116ec3bb5a5606bd278c5fe8f7372cee2bd17b5f7004cec9e7ce647"
    sha256 cellar: :any,                 arm64_ventura: "cf06663f10673cb44cd90f3ae233649e3e463b60a34f5772467fe274e9354267"
    sha256 cellar: :any,                 sonoma:        "0dbf4f7144c7e62d4713e1aebe0cbd1e1295231de1d3862196414ddc9c3ef68d"
    sha256 cellar: :any,                 ventura:       "6cff7983d7315e87ae15ae8c827fe616f4d77b6a1ba4850ff9e34424232ac921"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0b49de7317e22ca35e63f88e44ee3f29f476e0d04cd7586427563da89bb3ed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "795d1a206737d35ead3aefb0968b085d770073bf6fd6edd1ca5ea2b56920ae1e"
  end

  depends_on "doxygen" => :build
  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build

  depends_on "cffi"
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@3.13"
  depends_on "sfsexp"
  depends_on "talloc"
  depends_on "xapian"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def python3
    "python3.13"
  end

  def install
    ENV.cxx11 if OS.linux?
    site_packages = Language::Python.site_packages(python3)
    with_env(PYTHONPATH: Formula["sphinx-doc"].opt_libexec/site_packages) do
      system "./configure", "--prefix=#{prefix}",
                            "--mandir=#{man}",
                            "--emacslispdir=#{elisp}",
                            "--emacsetcdir=#{elisp}",
                            "--bashcompletiondir=#{bash_completion}",
                            "--zshcompletiondir=#{zsh_completion}",
                            "--without-ruby"
      system "make", "V=1", "install"
    end
    bin.install "notmuch-git"
    rewrite_shebang detected_python_shebang, bin/"notmuch-git"

    elisp.install Pathname.glob("emacs/*.el")
    bash_completion.install "completion/notmuch-completion.bash" => "notmuch"

    (prefix/"vim/plugin").install "vim/notmuch.vim"
    (prefix/"vim/doc").install "vim/notmuch.txt"
    (prefix/"vim").install "vim/syntax"

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./bindings/python-cffi"
  end

  test do
    (testpath/".notmuch-config").write <<~INI
      [database]
      path=#{testpath}/Mail
    INI
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")

    system python3, "-c", <<~PYTHON
      import notmuch2
      db = notmuch2.Database(mode=notmuch2.Database.MODE.READ_ONLY)
      assert str(db.path) == '#{testpath}/Mail', 'Wrong db.path!'
      db.close()
    PYTHON
    system bin/"notmuch-git", "-C", "#{testpath}/git", "init"
    assert_path_exists testpath/"git"
  end
end
