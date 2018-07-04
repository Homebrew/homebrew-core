class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel706.tar.gz"
  version "7.06"
  sha256 "bea3fba40305b6299a4a65a26f8e1f1caf844abec61588ff1c500e9c05047922"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "b0e3c6fa02ff351baf2032e31041dc9c085dea808a1cb3dbed1d426adb154c80" => :high_sierra
    sha256 "7ab3005586197881fcf49ca078495a788ac0ad1241e13eda3b5c32d5aa34aa7d" => :sierra
    sha256 "62679fd726fa45d2c20d507d7ccac0144bb74d3fbeb2a6479707fa0ddf6c09dc" => :el_capitan
  end

  deprecated_option "strict" => "with-strict"
  option "with-strict", "Compile in strict mode (not recommended)"

  depends_on "ocaml"

  def install
    args = ["--prefix", prefix, "--mandir", man]
    args << "--transitional" if build.without? "strict"

    system "./configure", *args
    system "make", "world.opt"
    system "make", "install"
    (lib/"ocaml/camlp5").install "etc/META"
  end

  test do
    (testpath/"hi.ml").write "print_endline \"Hi!\";;"
    assert_equal "let _ = print_endline \"Hi!\"", shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo #{lib}/ocaml/camlp5/pr_o.cmo hi.ml")
  end
end
