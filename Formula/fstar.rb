class Fstar < Formula
  desc "Language with a type system for program verification"
  homepage "https://www.fstar-lang.org/"
  url "https://github.com/FStarLang/FStar.git",
      :tag => "v0.9.4.0",
      :revision => "2137ca0fbc56f04e202f715202c85a24b36c3b29"
  head "https://github.com/FStarLang/FStar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fed93a145c1455025bb3e799f14ca456e5326147059e60655daf2b90d5d31765" => :sierra
    sha256 "af3a84d4b8fa2f76fe5863dd001aadb38200fe7409bac1ba1e5460b91ca2c72d" => :el_capitan
    sha256 "158cb0755c2b09565fc3d605e1bbf6e894c7176e69f707f9ee01a4d844d879b6" => :yosemite
  end

  depends_on "opam" => :build
  depends_on "gmp" => :build
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
      system "opam", "install", "batteries=2.5.3", "zarith=1.3", "yojson=1.1.6"
    else
      system "opam", "install", "batteries", "zarith", "yojson"
    end

    system "opam", "config", "exec", "--", "make", "-C", "src", "boot-ocaml"

    bin.install "src/ocaml-output/fstar.exe"

    (libexec/"stdlib").install Dir["lib/*"]
    (libexec/"contrib").install Dir["contrib/*"]
    (libexec/"examples").install Dir["examples/*"]
    (libexec/"tutorial").install Dir["doc/tutorial/*"]
    (libexec/"src").install Dir["src/*"]
    (libexec/"licenses").install "LICENSE-fsharp.txt", Dir["3rdparty/licenses/*"]

    prefix.install_symlink libexec/"stdlib"
    prefix.install_symlink libexec/"contrib"
    prefix.install_symlink libexec/"examples"
    prefix.install_symlink libexec/"tutorial"
    prefix.install_symlink libexec/"src"
    prefix.install_symlink libexec/"licenses"
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
    "--include", "#{prefix}/examples/unit-tests",
    "--admit_fsi", "FStar.Set",
    "FStar.Set.fsi", "FStar.Heap.fst",
    "FStar.ST.fst", "FStar.All.fst",
    "FStar.List.fst", "FStar.String.fst",
    "FStar.Int32.fst", "unit1.fst",
    "unit2.fst", "testset.fst"
  end
end
