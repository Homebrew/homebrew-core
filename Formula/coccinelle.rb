class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "http://coccinelle.lip6.fr/"
  url "https://github.com/coccinelle/coccinelle.git",
      tag:      "1.1.1",
      revision: "5444e14106ff17404e63d7824b9eba3c0e7139ba"
  license "GPL-2.0-only"
  head "https://github.com/coccinelle/coccinelle.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "ec7ef55264ac1fca61319d7f7df11cf3d6cfd4702a53e726209f62555e9b71d3"
    sha256 cellar: :any, arm64_big_sur:  "78e87db9e0aabffbddde513ae5100fc015792fd75c5bd1d5ca91bb53342b575c"
    sha256 cellar: :any, monterey:       "bc4160ec45c892d9b0df334eb6830474554d64bc398fc6735d7de7b532f9a663"
    sha256 cellar: :any, big_sur:        "f050cd80796be603afea32e24bd860c98543162d7e95e195902f5c267c2edaeb"
    sha256 cellar: :any, catalina:       "61befc08516da9ace4eecc7f4bbd8e8b041ed709ee5f9fc8024bf2667056c3e6"
    sha256 cellar: :any, mojave:         "4f2ca36bdd4c52eb8a074f047c231f41c941b5a1a4aa1624ec5301735e478c91"
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
