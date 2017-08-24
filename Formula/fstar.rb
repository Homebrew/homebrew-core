class Fstar < Formula
  desc "ML-like language aimed at program verification"
  homepage "https://www.fstar-lang.org/"
  url "https://github.com/FStarLang/FStar.git",
      :tag => "v0.9.5.0",
      :revision => "fa9b1fda52216678e364656f5f40b3309ef8392d"
  head "https://github.com/FStarLang/FStar.git"

  bottle do
    cellar :any
    sha256 "8f26eeac9a1fd10074b86e775093e1cdcbcb065bd54a9385237dfc27d36cf7cb" => :sierra
    sha256 "05e98f43735bbcb9dcd216d2ed3c530fb6b4496ea4436ecb0c4fbd3d0e7e86a9" => :el_capitan
    sha256 "a0fd22288390c7ff5b66db38300b1e90f1d28f0c3e0e88a5368301006a54b8db" => :yosemite
  end

  depends_on "opam" => :build
  depends_on "gmp"
  depends_on "ocaml" => :recommended
  depends_on "z3" => :recommended

  def install
    ENV.deparallelize # Not related to F* : OCaml parallelization
    ENV["OPAMROOT"] = buildpath/"opamroot"
    ENV["OPAMYES"] = "1"

    # Avoid having to depend on coreutils
    inreplace "src/ocaml-output/Makefile", "$(DATE_EXEC) -Iseconds",
                                           "$(DATE_EXEC) '+%Y-%m-%dT%H:%M:%S%z'"

    system "opam", "init", "--no-setup"
    inreplace "opamroot/compilers/4.05.0/4.05.0/4.05.0.comp",
      '["./configure"', '["./configure" "-no-graph"' # Avoid X11

    if build.stable?
      system "opam", "config", "exec", "opam", "install", "batteries=2.7.0",
             "zarith=1.5", "yojson=1.4.0", "pprint=20140424", "stdint=0.4.2",
             "menhir=20170712"
    else
      system "opam", "config", "exec", "opam", "install", "batteries", "zarith",
             "yojson", "pprint", "stdint", "menhir"
    end

    system "opam", "config", "exec", "--", "make", "-C", "src/ocaml-output"

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
    To compile the generated OCaml code, you must install
    some packages from the OPAM package manager:
    - brew install opam
    - opam install batteries zarith yojson pprint stdint menhir

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
