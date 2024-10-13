class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "https://coccinelle.gitlabpages.inria.fr/website/"
  url "https://github.com/coccinelle/coccinelle.git",
      tag:      "1.2",
      revision: "969cb12e9e9b7d4f42c2ff15296fd927f1ba63af"
  license "GPL-2.0-only"
  head "https://github.com/coccinelle/coccinelle.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia:  "6c1425bca745da7fb5ecf7ccdbe69794c317e8112aabea1b6d27907e3bafb8cf"
    sha256 arm64_sonoma:   "a36c5cfcdf9bf41142f9475fcc6ceb194241befb2e52649a4c71e53fb2602961"
    sha256 arm64_ventura:  "1393cf374ce5f991413ab0df0463ba44d40c2d82a4799e859d8b09fbab8ed42f"
    sha256 arm64_monterey: "ef00df9ef65948e04513d222ffdcad06bfc5b3a7637d4bd0db36de3d08f93678"
    sha256 sonoma:         "3bc8077e579e1115de4e84adea5d2a41a16ad39852e4dde6f275baea83490353"
    sha256 ventura:        "52d5a623ec3b372e8701375a04422eada24786d089dbeac052cae7a764cc8298"
    sha256 monterey:       "0a7f4a693f30a6369413d9a4cb80bde37a5c5216cffbe2b7db75681c425b2987"
    sha256 x86_64_linux:   "8a3a18a838b16ed3fd2adf8dae3cbecc2ae02018f661a0cb89c6db318ddec137"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "hevea" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
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
      system "opam", "exec", "--", "./configure", *std_configure_args,
                                                  "--disable-silent-rules",
                                                  "--enable-ocaml",
                                                  "--enable-opt",
                                                  "--without-pdflatex",
                                                  "--with-bash-completion=#{bash_completion}"
      ENV.deparallelize
      system "opam", "exec", "--", "make"
      system "make", "install"
    end

    pkgshare.install "demos/simple.cocci", "demos/simple.c"
  end

  test do
    system bin/"spatch", "-sp_file", "#{pkgshare}/simple.cocci",
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
