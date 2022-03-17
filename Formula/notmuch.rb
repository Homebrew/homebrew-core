class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.35.tar.xz"
  sha256 "a831c414c4f20a6cae3a580793c855102d3295080f000eb3832b77226a40ac39"
  license "GPL-3.0-or-later"
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4794d09aeec3a31ab42f446faccddafe437b4ba5bd3733cda47306416164ba3a"
    sha256 cellar: :any,                 arm64_big_sur:  "a6ad91582b6044c0bb56128e63b12cf574a4be7ecbc1ea92b092d6c1f94cf83e"
    sha256 cellar: :any,                 monterey:       "db79f0dc2fb3be4d30af78f2afce38bc4a2f726e9078f72a7b6f2a06bd1f35de"
    sha256 cellar: :any,                 big_sur:        "9d37afdac92c51c5513b02be5e64d574e7efb6a9116c4994ac0235e4955ca247"
    sha256 cellar: :any,                 catalina:       "959f1a2b48b723fe1d5996d29eb74a3a1179287e350977caea952c812250b65c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "179de9fb07f4c41ffc3714b85f3f3dcff995b50d50302de884fa92de6d92c8ea"
  end

  depends_on "doxygen" => :build
  depends_on "emacs" => :build
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
    ENV.cxx11 if OS.linux?

    system "./configure", *args
    system "make", "V=1", "install"

    elisp.install Dir["emacs/*.el"]
    bash_completion.install "completion/notmuch-completion.bash"

    (prefix/"vim/plugin").install "vim/notmuch.vim"
    (prefix/"vim/doc").install "vim/notmuch.txt"
    (prefix/"vim").install "vim/syntax"

    cd "bindings/python" do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    end

    # If installed in non-standard prefixes, such as is the default with
    # Homebrew on Apple Silicon machines, other formulae can fail to locate
    # libnotmuch.dylib due to not checking locations like /opt/homebrew for
    # libraries. This is a bug in notmuch rather than Homebrew; globals.py
    # uses a vanilla CDLL instead of CDLL wrapped with `find_library`
    # which effectively causes the issue.
    #
    # CDLL("libnotmuch.dylib") = OSError: dlopen(libnotmuch.dylib, 6): image not found
    # find_library("libnotmuch") = '/opt/homebrew/lib/libnotmuch.dylib'
    # http://notmuch.198994.n3.nabble.com/macOS-globals-py-issue-td4044216.html
    inreplace lib/"python3.9/site-packages/notmuch/globals.py",
               "libnotmuch.{0:s}.dylib",
               opt_lib/"libnotmuch.{0:s}.dylib"
  end

  test do
    (testpath/".notmuch-config").write "[database]\npath=#{testpath}/Mail"
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")
  end
end
