class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "http://coccinelle.lip6.fr/"
  url "https://github.com/coccinelle/coccinelle.git",
      tag:      "1.1.0",
      revision: "e84d3ddc7d4131b7e7e70c29d49eca09d35fabb6"
  license "GPL-2.0"
  head "https://github.com/coccinelle/coccinelle.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "45e6ce70f6c1221864c063f755607c40875b3265da4d9bd47687360ed6a05208"
    sha256 cellar: :any, big_sur:       "b05ace46f798c6abdd47fd764b52575d119b67c65b64a7257fff378fd6ca73ca"
    sha256 cellar: :any, catalina:      "cc2f0b1ff9f45f48c91f136b1b88ac6c7d2e34b475d77d1c0e418f1a47e691b2"
    sha256 cellar: :any, mojave:        "6dd3d84d54e00d9d7ce4b27f1693d266120221bd98c99d7988a58c802c26fab3"
    sha256 cellar: :any, high_sierra:   "c50aae7af14976966f3d3232ac89b4b2fb45753765e07377a39daf9aaeb22960"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "hevea" => :build
  depends_on "opam" => :build
  depends_on "ocaml"

  def install
    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      ENV["OPAMVERBOSE"] = "1"
      system "opam", "init", "--no-setup", "--disable-sandboxing"
      system "opam", "install", "ocamlfind"
      system "./autogen"
      system "opam", "config", "exec", "--", "./configure",
                            "--disable-dependency-tracking",
                            "--enable-release",
                            "--enable-ocaml",
                            "--enable-opt",
                            "--with-pdflatex=no",
                            "--prefix=#{prefix}"
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
