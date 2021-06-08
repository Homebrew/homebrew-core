class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.32.1.tar.xz"
  sha256 "a747ca4e8cc919d91feda6cadb97e63b72ff79119491989bbcea79ad47680615"
  license "GPL-3.0-or-later"
  revision 1
  head "https://git.notmuchmail.org/git/notmuch", using: :git

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0eb2700e35e3687842e99f38f8c197565ee9b6b139944525d5a6297f580cbaaf"
    sha256 cellar: :any, big_sur:       "e9abbef70a364c7d6f0a70365c71bf0f9681a2691ad4062d5c323d139ab5dd9f"
    sha256 cellar: :any, catalina:      "582b27d35ec3dcf8924b1a8bac9c56dc97ca93410a1b9ed23ecb65b8e2f942b9"
    sha256 cellar: :any, mojave:        "0f89750eb2ab0fd7361470777f0eea4196852f68cbae1e78d2e2b493ab682545"
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

  # Remove in the release after 0.32.1
  patch do
    url "https://git.notmuchmail.org/git?p=notmuch;a=patch;h=59c953656dbd2e65265a2c850f2375afc9d69589;hp=92454bc0935604f4a623e75dec9506c0283eee70"
    sha256 "291066e48a26e8f78504413203685bedc77a35d0c8f94143e1daa058b444235e"
  end

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
