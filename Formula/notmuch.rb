class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.30.tar.xz"
  sha256 "5e3baa6fe11d65c67e26ae488be11b320bae04e336acc9c64621f7e3449096fa"
  head "https://git.notmuchmail.org/git/notmuch", :using => :git

  bottle do
    cellar :any
    rebuild 1
    sha256 "789d748a2d59bd2df69de4f0f3d5e42fb6fa7e7e739ca2b86fd8a85408088b99" => :catalina
    sha256 "f3fb3267ac22265010553b2f72c1fb1c2b997a31759859a8e68a93cadf3bf9c1" => :mojave
    sha256 "7f2d8203b81fd29dde272a18f98235e31b43c28fc6e847906a79a0fa72219f6b" => :high_sierra
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
