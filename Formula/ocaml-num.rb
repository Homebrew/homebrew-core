class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/v1.4.tar.gz"
  sha256 "015088b68e717b04c07997920e33c53219711dfaf36d1196d02313f48ea00f24"
  license "LGPL-2.1"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8a5d1c3625dc2fb163fed6576507e859f4d117b9612a69c8569d6047de63f9dd"
    sha256 cellar: :any,                 arm64_big_sur:  "f1f22afab148209110159c9fcbe9cdfd7f27ca6a25b55ddd11358c130da033fb"
    sha256 cellar: :any,                 monterey:       "b8812394abf008510cf45d72e0d136203a1fe5c93ed7dd2be50e251ad34d249c"
    sha256 cellar: :any,                 big_sur:        "4563053ebf720e623e0afeb935f803ab1aedc3c15d6d99d6bc2818301eeb4ecb"
    sha256 cellar: :any,                 catalina:       "26b165d15abd314baafa8c8a055236684eb26ae86740d85edca087321c5c311c"
    sha256 cellar: :any,                 mojave:         "c14f476a964f149d3dc3145cb219286fea6585962351ada79aa1ed4606d9f781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a73e9edb89bf0770888357b1d3020a704bbb068cf3cede057db573ed0f4f7be2"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "ocaml"

  def install
    ENV["OCAMLFIND_DESTDIR"] = lib/"ocaml"

    (lib/"ocaml").mkpath
    cp Formula["ocaml"].opt_lib/"ocaml/Makefile.config", lib/"ocaml"

    # install in #{lib}/ocaml not #{HOMEBREW_PREFIX}/lib/ocaml
    inreplace lib/"ocaml/Makefile.config" do |s|
      s.change_make_var! "prefix", prefix
    end

    system "make"
    (lib/"ocaml/stublibs").mkpath # `make install` assumes this directory exists
    system "make", "install", "STDLIBDIR=#{lib}/ocaml"

    pkgshare.install "test"

    rm lib/"ocaml/Makefile.config" # avoid conflict with ocaml
  end

  test do
    cp_r pkgshare/"test/.", "."
    system Formula["ocaml"].opt_bin/"ocamlopt", "-I", lib/"ocaml", "-I",
           Formula["ocaml"].opt_lib/"ocaml", "-o", "test", "nums.cmxa",
           "test.ml", "test_nats.ml", "test_big_ints.ml", "test_ratios.ml",
           "test_nums.ml", "test_io.ml", "end_test.ml"
    assert_match "1... 2... 3", shell_output("./test")
  end
end
