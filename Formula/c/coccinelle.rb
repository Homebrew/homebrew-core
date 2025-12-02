class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "https://coccinelle.gitlabpages.inria.fr/website/"
  url "https://github.com/coccinelle/coccinelle.git",
      tag:      "1.3.0",
      revision: "e1906ad639c5eeeba2521639998eafadf989b0ac"
  license "GPL-2.0-only"
  head "https://github.com/coccinelle/coccinelle.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 3
    sha256 arm64_tahoe:   "6674635eed7e10d0c59addbe4334400c00fce2757a0b976dcf6bc9c26f7a7232"
    sha256 arm64_sequoia: "0faa904330204e02b784ec7e6c99a15617729ad7ac81f6ed66402b6f7e666d12"
    sha256 arm64_sonoma:  "0b15c96cad2e7deb89c174cfe2ee50d29cae1fa30e7dcc622784e7efad86e635"
    sha256 sonoma:        "c3c10e081708afbc74243fe20cb096da013911b3cd7ffe4a0bb759e8c05170ad"
    sha256 arm64_linux:   "fe10716f2b88622a10a28155bf96c10a20ddca724fc73edd6a2b758cd4fe39bc"
    sha256 x86_64_linux:  "2d29e8edd51256bcc58964055ca65ebf75a7ebaf953be4d8300cb127817bdd8a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "hevea" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "ocaml"
  depends_on "pcre"

  uses_from_macos "unzip" => :build

  def install
    ENV["OPAMROOT"] = buildpath/".opam"
    ENV["OPAMYES"] = "1"
    ENV["OPAMVERBOSE"] = "1"
    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    system "opam", "install", ".", "--deps-only", "--yes", "--no-depexts"
    system "./autogen"
    system "opam", "exec", "--", "./configure", "--disable-silent-rules",
                                                "--enable-ocaml",
                                                "--enable-opt",
                                                "--without-pdflatex",
                                                "--with-bash-completion=#{bash_completion}",
                                                *std_configure_args
    ENV.deparallelize
    system "opam", "exec", "--", "make"
    system "make", "install"

    pkgshare.install "demos/simple.cocci", "demos/simple.c"
  end

  test do
    system bin/"spatch", "-sp_file", "#{pkgshare}/simple.cocci", "#{pkgshare}/simple.c", "-o", "new_simple.c"
    expected = <<~C
      int main(int i) {
        f("ca va", 3);
        f(g("ca va pas"), 3);
      }
    C

    assert_equal expected, (testpath/"new_simple.c").read
  end
end
