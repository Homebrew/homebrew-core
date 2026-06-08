class Notmuch < Formula
  include Language::Python::Shebang

  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.40.tar.xz"
  sha256 "4b4314bbf1c2029fdf793637e6c7bb15c1b1730d22be9aa04803c98c5bbc446f"
  license "GPL-3.0-or-later"
  revision 1
  compatibility_version 1
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eae24f49c3b10abfde979af48095a1a57930ed5bdcbc6812ccc54a19bad10860"
    sha256 cellar: :any,                 arm64_sequoia: "421174ec9e5af1051572972811fa7062bd3d6e680d5881c8a11e4f538b42505f"
    sha256 cellar: :any,                 arm64_sonoma:  "15d1e06cdc2fee25afe4812f6482d3775cf4302c5a3f66b60935322cbf9fbf1c"
    sha256 cellar: :any,                 sonoma:        "2b990b337a8c0ed0e2e086703ae947ee5b1fbfcb3131404855faf319032c0693"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c55b7b11e0bbe8128902da95371f0ddf2c4f25b248f54aaca9ddbdb1c12b74f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9f8bd8f09dc8ccf7665e5adaba42916d2023ddc4c3420d4d5472ef1c1a784d6"
  end

  depends_on "doxygen" => :build
  depends_on "emacs" => :build
  depends_on "gnupg" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build

  depends_on "cffi"
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@3.14"
  depends_on "sfsexp"
  depends_on "talloc"
  depends_on "xapian"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def python3
    "python3.14"
  end

  def install
    ENV.append "CXXFLAGS", "-std=c++17"
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
    system bin/"notmuch-git", "-C", testpath/"git", "init"
    assert_path_exists testpath/"git"
  end
end
