class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "http://coccinelle.lip6.fr/"
  url "https://github.com/coccinelle/coccinelle.git",
      tag:      "1.1.1",
      revision: "5444e14106ff17404e63d7824b9eba3c0e7139ba"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/coccinelle/coccinelle.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "c36d64915f8f1fb1d3f1b11affa180d87cce7c2fab525ca5d43e000d6552ac84"
    sha256 arm64_monterey: "6d709b2576f84260edf15ed3a6c4e4b4e0cc73bde3819f9d9085f964c761b155"
    sha256 arm64_big_sur:  "43e22010b8b1f3bf93817d161e2d0e96d907f4a38972d27f91d0231042f70860"
    sha256 ventura:        "7d44848e93251045e263c647aa95c2fd7639ab2918dcdea672ea12115c0f922d"
    sha256 monterey:       "9e00a25cc6afe398d4a5ae42300bacd883bf1f570e6c1523ffb43bd3d330ae30"
    sha256 big_sur:        "270fe7690278277362ebf04707665ae41e3831c21e33d945408f2e7d9737669e"
    sha256 catalina:       "27b442146b362f44848997fa840389ff9df05317e915147d289a74e1ef4c5a68"
    sha256 x86_64_linux:   "29a0aeaeb102990cac27cdc3ecc713f2af6366f38c5d3cefb520ef70dcd2fa84"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "hevea" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "ocaml"
  depends_on "pcre"

  uses_from_macos "unzip" => :build

  # Bootstap resource for Ocaml 4.12 compatibility.
  # Remove when Coccinelle supports Ocaml 4.12 natively
  resource "stdcompat" do
    url "https://github.com/thierry-martinez/stdcompat/releases/download/v15/stdcompat-15.tar.gz"
    sha256 "5e746f68ffe451e7dabe9d961efeef36516b451f35a96e174b8f929a44599cf5"
  end

  def install
    resource("stdcompat").stage do
      system "./configure", "--prefix=#{buildpath}/bootstrap"
      ENV.deparallelize { system "make" }
      system "make", "install"
    end
    ENV.prepend_path "OCAMLPATH", buildpath/"bootstrap/lib"

    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      ENV["OPAMVERBOSE"] = "1"
      system "opam", "init", "--no-setup", "--disable-sandboxing"
      system "./autogen"
      system "opam", "config", "exec", "--", "./configure",
                            "--disable-dependency-tracking",
                            "--enable-release",
                            "--enable-ocaml",
                            "--enable-opt",
                            "--with-pdflatex=no",
                            "--prefix=#{prefix}",
                            "--libdir=#{lib}"
      ENV.deparallelize
      system "opam", "config", "exec", "--", "make"
      system "make", "install"
    end

    pkgshare.install "demos/simple.cocci", "demos/simple.c"
  end

  test do
    system "#{bin}/spatch", "-sp_file", "#{pkgshare}/simple.cocci",
                            "#{pkgshare}/simple.c", "-o", "new_simple.c"
    expected = <<~EOS
      int main(int i) {
        f("ca va", 3);
        f(g("ca va pas"), 3);
      }
    EOS
    assert_equal expected, (testpath/"new_simple.c").read
  end
end
