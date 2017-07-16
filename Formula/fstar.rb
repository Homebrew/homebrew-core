class Fstar < Formula
  desc "ML-like language aimed at program verification"
  homepage "https://www.fstar-lang.org/"
  url "https://github.com/FStarLang/FStar.git",
      :tag => "v0.9.4.0",
      :revision => "2137ca0fbc56f04e202f715202c85a24b36c3b29"
  revision 2
  head "https://github.com/FStarLang/FStar.git"

  bottle do
    cellar :any
    sha256 "dbd43955ad872d0c7217f9d7f2c0140ca6114a162ac41b73c6dba50f7637c0ce" => :sierra
    sha256 "55f4d2b1397c5087574f6103c4849b7167c9d094ae8293d59a59be674c3dd93a" => :el_capitan
    sha256 "d24224b03bbb333691295e99e3322a2a5b4729d97d3d3aeac82beafab7af5274" => :yosemite
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
    inreplace "opamroot/compilers/4.04.2/4.04.2/4.04.2.comp",
      '["./configure"', '["./configure" "-no-graph"' # avoid X11

    # remove when the OPAM deps have OCaml 4.05.0 compatible versions
    system "opam", "switch", "4.04.2"

    if build.stable?
      system "opam", "config", "exec", "opam", "install", "batteries=2.5.3",
             "zarith=1.4.1", "yojson=1.3.3", "pprint=20140424"
    else
      system "opam", "config", "exec", "opam", "install", "batteries", "zarith",
             "yojson", "pprint"
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
