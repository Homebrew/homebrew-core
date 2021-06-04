class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "http://coccinelle.lip6.fr/"
  url "https://github.com/coccinelle/coccinelle.git",
      tag:      "1.1.0",
      revision: "25e7cee77b4b6efbabf60ffaa8bccd72500ba8bd"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/coccinelle/coccinelle.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "73d90cfa6837ada22b780c32a9140f390f4c1edf75efaead1611451e499af0a2"
    sha256 cellar: :any, big_sur:       "93341040702939158171021a18b27284b50c44b61df0b23aa61f9bf86cba771c"
    sha256 cellar: :any, catalina:      "3033a6317a08b4816a46c61d2b07ceeabde0a24ff226634ce4c206af2b718b7a"
    sha256 cellar: :any, mojave:        "ee53ae5fa8349a8d1c26bc21fdfd073586c83cf0831eec4880558b0c5f743a68"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "hevea" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "ocaml"
  depends_on "pcre"

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
