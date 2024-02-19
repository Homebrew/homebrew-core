class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "https://coccinelle.gitlabpages.inria.fr/website/"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/coccinelle/coccinelle.git", branch: "master"

  stable do
    url "https://github.com/coccinelle/coccinelle.git",
        tag:      "1.1.1",
        revision: "5444e14106ff17404e63d7824b9eba3c0e7139ba"

    # Backport compatibility with OCaml 5. Remove in the next release.
    patch do
      url "https://github.com/coccinelle/coccinelle/commit/f13b03aa20a08e5187ce36bfd5e606f18acd2888.patch?full_index=1"
      sha256 "84f06551652d9fcee63451fe8d3bce3845c01fe054087cde50bb3b8308014445"
    end
    patch do
      url "https://github.com/coccinelle/coccinelle/commit/1d0733a27006b06eef712f541000a8bf10246804.patch?full_index=1"
      sha256 "391ee079fc18ac4727af089fdf686cd41d4b2ba7847c4bcf2b3b04caf5b6d457"
    end

    # Backport usage of non-bundled packages to allow versions installed by opam
    patch do
      url "https://github.com/coccinelle/coccinelle/commit/3f54340c8ac907e528dbe1475a4a7141e77b9cdd.patch?full_index=1"
      sha256 "94b23b53c023270368601bc5debefc918a99f87b7489e25acddf9c967ddb4486"
    end
    patch do
      url "https://github.com/coccinelle/coccinelle/commit/2afa9f669b565badf17104176cc4850a2dff67f6.patch?full_index=1"
      sha256 "882fe080f7fbce4b0f08b8854a5b02212c17efbc2a62c145eae562842d8e2337"
    end
    patch do
      url "https://github.com/coccinelle/coccinelle/commit/d9ce82a556e313684af74912cf204bb902e04436.patch?full_index=1"
      sha256 "4b27d81d27363efb1a83064abba1df1c09a1f1f064c81cc621ca61b79f58d83e"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "ca6145d84ac088d6a9af56409383ee95fcdfc019d565f57a16ab6571b468df10"
    sha256 arm64_ventura:  "cb7b2f3f20840b99f22efba6538fd4e7a6fa3868aa9f934c5722e26a968dc753"
    sha256 arm64_monterey: "368b32215f0409f8686364f2d5f9fa6d6ef3896ae1baddba37ad34abc2021a8a"
    sha256 sonoma:         "6e9fcb9482970a2459a8e6bc4b319cd06d555dbfcd6501ad5cae9d9fc8dad61b"
    sha256 ventura:        "60b09a4b123954c6a206cfa471c8653622f9567f786eb183241b1cd55f412128"
    sha256 monterey:       "108f9640319df581d2feb12d6f52540d7f30876d24f48547e2a901ddda474aed"
    sha256 x86_64_linux:   "1d24df746aee06ce03219fb78ff208b30b7b14c666195e30623c9012c9f825ea"
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
