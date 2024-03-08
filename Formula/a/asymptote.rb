class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.88/asymptote-2.88.src.tgz"
  sha256 "0de71a743fa6ee9391b87dd275cb3fe4cdef51b37aae14a416834dd12a2af5bb"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "42f2d0ab5ea7ba91cbe25be945175a527c54f350a6dadb09ad81e666f50eb516"
    sha256 arm64_ventura:  "56f6b7a68057a8c1c2aa344544ebf4acc8019d002504ea4af9517a8b4e653e85"
    sha256 arm64_monterey: "4ca4b659c0c063fa150f81932e540876820764266709ec2e50e19ae86d2e146d"
    sha256 sonoma:         "6d43c8ea58c8ea2e467c5bfcd3a70d5499d9edacea8f44a19680b2b0632e7ff4"
    sha256 ventura:        "577f60086bf5186207c31c972a4655acb6fdd3b12abb3c8e4d17515d7214cd17"
    sha256 monterey:       "f8650f9c52df5a795a068ccdb538a8b47adefc2467249d60af98fafd0804aa69"
    sha256 x86_64_linux:   "01bfb84f5b327e163eb523b9c950d68c54ac9ee0f94973aa0a040d74e6eb2f36"
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "freeglut"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.88/asymptote.pdf"
    sha256 "7597b5ab25484ec77c472606e0eea057bb47efc97d8c638df51357d9e8d1b4ab"
  end

  def install
    odie "manual resource needs to be updated" if version != resource("manual").version

    system "./configure", *std_configure_args

    # Avoid use of MacTeX with these commands
    # (instead of `make all && make install`)
    touch buildpath/"doc/asy-latex.pdf"
    system "make", "asy"
    system "make", "asy-keywords.el"
    system "make", "install-asy"

    doc.install resource("manual")
    (share/"emacs/site-lisp").install_symlink pkgshare
  end

  test do
    (testpath/"line.asy").write <<~EOF
      settings.outformat = "pdf";
      size(200,0);
      draw((0,0)--(100,50),N,red);
    EOF

    system bin/"asy", testpath/"line.asy"
    assert_predicate testpath/"line.pdf", :exist?
  end
end
