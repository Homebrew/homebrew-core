class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/refs/tags/v1.6.tar.gz"
  sha256 "b5cce325449aac746d5ca963d84688a627cca5b38d41e636cf71c68b60495b3e"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7d97a11ca99de9facad637811bf78e035b5a5ad856b19b80c587e37f8e9c0628"
    sha256 cellar: :any, arm64_sequoia: "154565a6ae34f0f39ae5d49fc210cfe30b96fc28a696cac9c959caa41492423b"
    sha256 cellar: :any, arm64_sonoma:  "fa6c8ca8310d041378a0afc352c4e7493d184975d897c10d7fee8b7bbb1968d3"
    sha256 cellar: :any, sonoma:        "f395332e2c24a0b5a1ddb7bc7805ffff5a9760b521cd40597a552ef82b8eaa81"
    sha256 cellar: :any, arm64_linux:   "eda1ad6028d87729064c9db02372bfc62c0a8bfe5ddac5a72671327c267f4e57"
    sha256 cellar: :any, x86_64_linux:  "8528646cb785d24c4463a68e687c791eee4c36ca854daa37f799fe322240a8ce"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "ocaml"

  def install
    ENV["OCAMLFIND_DESTDIR"] = lib/"ocaml"

    # Work around https://github.com/ocaml/num/issues/43
    inreplace "src/Makefile", "cp META.num META", "mv META.num META"

    (lib/"ocaml").mkpath
    cp formula_opt_lib("ocaml")/"ocaml/Makefile.config", lib/"ocaml"

    # install in #{lib}/ocaml not #{HOMEBREW_PREFIX}/lib/ocaml
    inreplace lib/"ocaml/Makefile.config" do |s|
      s.change_make_var! "prefix", prefix
    end

    ENV.deparallelize { system "make" }
    (lib/"ocaml/stublibs").mkpath # `make install` assumes this directory exists
    system "make", "install", "STDLIBDIR=#{lib}/ocaml"

    pkgshare.install "test"

    rm lib/"ocaml/Makefile.config" # avoid conflict with ocaml
  end

  test do
    cp_r pkgshare/"test/.", "."
    system formula_opt_bin("ocaml")/"ocamlopt", "-I", lib/"ocaml", "-I",
           formula_opt_lib("ocaml")/"ocaml", "-o", "test", "nums.cmxa",
           "test.ml", "test_nats.ml", "test_big_ints.ml", "test_ratios.ml",
           "test_nums.ml", "test_io.ml", "end_test.ml"
    assert_match "1... 2... 3", shell_output("./test")
  end
end
