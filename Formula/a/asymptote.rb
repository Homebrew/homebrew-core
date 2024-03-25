class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.89/asymptote-2.89.src.tgz"
  sha256 "f64e62b4ee4f85f1a78640c4f1e8a6f98e91f54edacab19727c7cabe94a57f5b"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "b4391c8b620b185ad515fc5a4231d3cc91ba3c14141e628a2df648d065693f2a"
    sha256 arm64_ventura:  "cd5272505690c2a2fa20c5c5b9d94bf6095dbac528a59d7e1d77376661c9e2c5"
    sha256 arm64_monterey: "57ca55dcaa13cafa388c2eb6674c3263cd859c2ecc03acd2941f1a0d36e781cc"
    sha256 sonoma:         "dd179223630ac07ecacff4e201c54da76a5779cfa4c0614c5365a3a3ec5066d7"
    sha256 ventura:        "ae6b041de51a37329f07361c9e164a0e95ca7f3bc287b7fbf5db1a9bf3414eac"
    sha256 monterey:       "0e4936bbd458f85c5c4c5f0f1b29dfd2d4b05bda7175cbdcea7899b9e86578a9"
    sha256 x86_64_linux:   "2f56e57c07516a56e358875328d7ca50f4033b22565fc4034c31c2a3123630ca"
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
    url "https://downloads.sourceforge.net/project/asymptote/2.89/asymptote.pdf"
    sha256 "c14f388e05d814462693f04090ad18d9090a5eadd885e5287d1cde3788a5160b"
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
