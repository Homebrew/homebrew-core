class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  # NOTE: Keep this in sync with notmuch-mutt.
  url "https://notmuchmail.org/releases/notmuch-0.33.2.tar.xz"
  sha256 "244892f6ab52a84f6b013b387cd6652d461effd36b14ef9e576604b5850b2cae"
  license "GPL-3.0-or-later"
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "19a4915d3f8c1aa97bc78e77121cbdbe11a4647415865f4b38fb2dcf147beee3"
    sha256 cellar: :any,                 big_sur:       "2052642bf19bff4a20e4a4103b24900c3d839817653a591cc4eb339a17c560aa"
    sha256 cellar: :any,                 catalina:      "4edc75b0e0a4afb9077dbcfb2d0f424c042ba034d72ba5b8b6d2bc2d5ee4d939"
    sha256 cellar: :any,                 mojave:        "0857fa398d721fd77960c3150332f2b50b665e7505a0c726f2207c4f1ec956ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b59b68037db892584372fb30f15ba88673755158a5ac514435cc38495dfe0dbf"
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
