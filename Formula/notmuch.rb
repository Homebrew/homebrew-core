class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.32.2.tar.xz"
  sha256 "8e0a7eb8ff2e6011ef48b2bf11d79b9c4bb74511cfe2987758b64898c2a2ded7"
  license "GPL-3.0-or-later"
  head "https://git.notmuchmail.org/git/notmuch", using: :git

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d8529ee44554e96bb5ffaa1afecf48e9d3d9e76295217b3c6c798702a027370f"
    sha256 cellar: :any,                 big_sur:       "0f8769ef93addb20475aa9c17ca144358c66b068cc6467d43c5464633cee5355"
    sha256 cellar: :any,                 catalina:      "c3ba8b9912ef53894f73f5005cd13e20769cf1fc49df8017ab985225f3f0f68c"
    sha256 cellar: :any,                 mojave:        "8bb7a7a888f98972f63d05c62de0cef1613338abc70810d01ff5d5f0cb834ee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52de489510b6d6c8c905ca6a1c34d4a55a41d8cdee984fa06ce027c145f1107b"
  end

  option "without-brew-emacs", "Build Elisp files with Emacs without requiring the Homebrew Emacs formula"

  depends_on "doxygen" => :build
  depends_on "emacs" => :build unless build.without?("brew-emacs")
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
