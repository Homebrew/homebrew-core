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
    rebuild 2
    sha256 arm64_sequoia: "779d42bbb44aae1403be58912eec82d4a2dfda1506f02659a411e22496049cf0"
    sha256 arm64_sonoma:  "51cb6d4013905449b1a20a622cd95dce5ad64cdc37b6b92eda79ab7b23ed598b"
    sha256 arm64_ventura: "cd9aeeaa7d72f22a8d9e4e7a211e0c634e045abc7be0ca46dfa5b69b8ae29769"
    sha256 sonoma:        "cd5a22c0db4ce7dbea0ba1b2c3306527f96b5830cdda41099d559faab14b8ef4"
    sha256 ventura:       "032e447251705797000b9e3e86afe2a5da3f96ec1d6d26d4492f9cd6336e8e32"
    sha256 arm64_linux:   "47bd69526b59084f30deed93c35ee9b4fa81494524489580f1a60cff5028d3a0"
    sha256 x86_64_linux:  "5a7edb3aa8cd3da9381de308c27b703a4026584f259eeed0257c2cacd560df6d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "hevea" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "ocaml"
  depends_on "pcre"

  uses_from_macos "unzip" => :build

  def install
    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      ENV["OPAMVERBOSE"] = "1"
      system "opam", "init", "--no-setup", "--disable-sandboxing"
      system "opam", "exec", "--", "opam", "install", ".", "--deps-only", "-y", "--no-depexts"
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
    end

    pkgshare.install "demos/simple.cocci", "demos/simple.c"
  end

  test do
    system bin/"spatch", "-sp_file", "#{pkgshare}/simple.cocci", "#{pkgshare}/simple.c", "-o", "new_simple.c"
    expected = <<~EOS
      int main(int i) {
        f("ca va", 3);
        f(g("ca va pas"), 3);
      }
    EOS

    assert_equal expected, (testpath/"new_simple.c").read
  end
end
