class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "http://coccinelle.lip6.fr/"
  url "https://github.com/coccinelle/coccinelle.git",
      tag:      "1.1.0",
      revision: "e84d3ddc7d4131b7e7e70c29d49eca09d35fabb6"
  license "GPL-2.0-only"
  head "https://github.com/coccinelle/coccinelle.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "999cd887edc470102f1e318fbe59ad68a60786a8447a8e55ee453b5fe36f5008"
    sha256 cellar: :any, big_sur:       "48c2002495d02950c1f6caa2b330d435d57f20ecda6a80b3912df5a11ae0c3b0"
    sha256 cellar: :any, catalina:      "3705b898ce264c250741a0b464e0e87b53dcc658aa46ca82ae2e59a7bd19a00c"
    sha256 cellar: :any, mojave:        "3bd2cb4ba4904b6eb84961a282d19ee8edb725af1ffd3b85ec378aaa873df8b0"
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
