class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org"
  url "https://notmuchmail.org/releases/notmuch-0.22.tar.gz"
  sha256 "d64118ef926ba06fba814a89a75d20b0c8c8ec07dd65e41bb9f1e9db0dcfb99a"

  bottle do
    cellar :any
    sha256 "0caa82ec8a459275d5386585bdf944a6892b0fe499b2cb7b96243fed91c09b3a" => :el_capitan
    sha256 "1f7ac589626fd82ce3de8a399f6cd832982ee756c6d4fa618a62de461d200ca1" => :yosemite
    sha256 "6e5950e4159217dc865277576e3c75875269a286fb26a8e3a3e52987e651717f" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gmime"
  depends_on "talloc"
  depends_on "xapian"
  depends_on :emacs => ["21.1", :optional]
  depends_on :python => :optional
  depends_on :python3 => :optional
  depends_on :ruby => ["1.9", :optional]

  # Requires zlib >= 1.2.5.2
  resource "zlib" do
    url "http://zlib.net/zlib-1.2.8.tar.gz"
    sha256 "36658cb768a54c1d4dec43c3116c27ed893e88b02ecfcb44f2166f9c0b7f2a0d"
  end

  def install
    resource("zlib").stage do
      system "./configure", "--prefix=#{buildpath}/zlib", "--static"
      system "make", "install"
      ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/zlib/lib/pkgconfig"
    end

    args = ["--prefix=#{prefix}"]

    if build.with? "emacs"
      ENV.deparallelize # Emacs and parallel builds aren't friends
      args << "--with-emacs" << "--emacslispdir=#{elisp}" << "--emacsetcdir=#{elisp}"
    else
      args << "--without-emacs"
    end

    args << "--without-ruby" if build.without? "ruby"

    system "./configure", *args
    system "make", "V=1", "install"

    Language::Python.each_python(build) do |python, _version|
      cd "bindings/python" do
        system python, *Language::Python.setup_install_args(prefix)
      end
    end
  end

  test do
    system "#{bin}/notmuch", "help"
  end
end
