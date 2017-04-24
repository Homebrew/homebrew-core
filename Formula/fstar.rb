class Fstar < Formula
  desc "ML-like language aimed at program verification"
  homepage "https://www.fstar-lang.org/"
  url "https://github.com/FStarLang/FStar.git",
      :tag => "v0.9.4.0",
      :revision => "2137ca0fbc56f04e202f715202c85a24b36c3b29"
  revision 1
  head "https://github.com/FStarLang/FStar.git"

  bottle do
    cellar :any
    sha256 "9021919136bf13c486c3594801a247db59c2c675dad6ac42e7a4a320ec8e76b1" => :sierra
    sha256 "500f9933149f1b8149cbc91475d150bfff1a03a3d66f58978fa6dcdb8fd0bd1b" => :el_capitan
    sha256 "3736e3c9c1baedd1b6eaff6217fe90d54c50f026b6f5161bfae1b8168b260224" => :yosemite
  end

  depends_on "opam" => :build
  depends_on "gmp"
  depends_on "ocaml" => :recommended
  depends_on "z3" => :recommended

  def install
    ENV.deparallelize # Not related to F* : OCaml parallelization
    ENV["OPAMROOT"] = buildpath/"opamroot"
    ENV["OPAMYES"] = "1"

    # avoid having to depend on coreutils
    inreplace "src/ocaml-output/Makefile", "$(DATE_EXEC) -Iseconds",
                                           "$(DATE_EXEC) '+%Y-%m-%dT%H:%M:%S%z'"

    system "opam", "init", "--no-setup"

    if build.stable?
      system "opam", "install", "batteries=2.5.3", "zarith=1.4.1", "yojson=1.3.3", "pprint=20140424"
    else
      system "opam", "install", "batteries", "zarith", "yojson", "pprint"
    end

    system "opam", "config", "exec", "--", "make", "-C", "src", "boot-ocaml"

    (libexec/"bin").install "bin/fstar.exe"
    (bin/"fstar.exe").write <<-EOS.undent
      #!/bin/sh
      #{libexec}/bin/fstar.exe --fstar_home #{prefix} "$@"
    EOS

    (libexec/"ulib").install Dir["ulib/*"]
    (libexec/"contrib").install Dir["ucontrib/*"]
    (libexec/"examples").install Dir["examples/*"]
    (libexec/"tutorial").install Dir["doc/tutorial/*"]
    (libexec/"src").install Dir["src/*"]
    prefix.install "LICENSE-fsharp.txt"

    prefix.install_symlink libexec/"ulib"
    prefix.install_symlink libexec/"contrib"
    prefix.install_symlink libexec/"examples"
    prefix.install_symlink libexec/"tutorial"
    prefix.install_symlink libexec/"src"
  end

  def caveats; <<-EOS.undent
    F* code can be extracted to OCaml code.
    To compile the generated OCaml code, you must install the
    package 'batteries' from the Opam package manager:
    - brew install opam
    - opam install batteries

    F* code can be extracted to F# code.
    To compile the generated F# (.NET) code, you must install
    the 'mono' package that includes the fsharp compiler:
    - brew install mono
    EOS
  end

  test do
    system "#{bin}/fstar.exe",
    "#{prefix}/examples/hello/hello.fst"
  end
end
