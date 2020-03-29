class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "http://coccinelle.lip6.fr/"
  url "https://github.com/coccinelle/coccinelle.git",
      :tag      => "1.0.8",
      :revision => "d678c34afc0cfb479ad34f2225c57b1b8d3ebeae"
  head "https://github.com/coccinelle/coccinelle.git"

  bottle do
    cellar :any
    sha256 "cc2f0b1ff9f45f48c91f136b1b88ac6c7d2e34b475d77d1c0e418f1a47e691b2" => :catalina
    sha256 "6dd3d84d54e00d9d7ce4b27f1693d266120221bd98c99d7988a58c802c26fab3" => :mojave
    sha256 "c50aae7af14976966f3d3232ac89b4b2fb45753765e07377a39daf9aaeb22960" => :high_sierra
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
