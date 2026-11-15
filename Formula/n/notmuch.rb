class Notmuch < Formula
  include Language::Python::Shebang

  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.40.tar.xz"
  sha256 "4b4314bbf1c2029fdf793637e6c7bb15c1b1730d22be9aa04803c98c5bbc446f"
  license "GPL-3.0-or-later"
  revision 2
  compatibility_version 1
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2e1708161869373851540083096abd8e9b1c5368090bd723305a5a69f33bb546"
    sha256 cellar: :any, arm64_tahoe:       "961f7f1a9ccbc6e2366dcfb9151a0d583cc93b684c6f075a44a4f4391795e9f4"
    sha256 cellar: :any, arm64_sequoia:     "ddc2f6bf7fcfc4ee641bf56cb740f8d95c7bc45682dbf705edb8d774c34511fb"
    sha256 cellar: :any, arm64_linux:       "e5276268db067b50074ab07691a08a4184c7928c8b6d13920c0a551f3179fd51"
    sha256 cellar: :any, x86_64_linux:      "34c81be86029b5b45f58da85b42c834a236243d8788d1423a308fe5682916711"
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
  depends_on "python@3.15"
  depends_on "sfsexp"
  depends_on "talloc"
  depends_on "xapian"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.append "CXXFLAGS", "-std=c++17"
    site_packages = Language::Python.site_packages(python3)
    with_env(PYTHONPATH: formula_opt_libexec("sphinx-doc")/site_packages) do
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
