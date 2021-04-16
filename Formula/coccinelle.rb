class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "http://coccinelle.lip6.fr/"
  url "https://github.com/coccinelle/coccinelle.git",
      tag:      "1.1.0",
      revision: "e84d3ddc7d4131b7e7e70c29d49eca09d35fabb6"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/coccinelle/coccinelle.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b5ca24e58034e0508e39b726b79b5c357251d98e7901bd4b7f2e4ff2ad378cb0"
    sha256 cellar: :any, big_sur:       "f2ae96a0c2ae00d31ba0c1014b960af9ac6e283559f4dad9e0576e0356bfc750"
    sha256 cellar: :any, catalina:      "808ea650f39c39e91f0699864651762b4f5dbbb51e68c6a6503662b650509dae"
    sha256 cellar: :any, mojave:        "90144f713b2f9b3658889689bfae1ce5e75aab916fbd0196edbfe3c5969567d5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "hevea" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "opam" => :build
  depends_on "ocaml"

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
