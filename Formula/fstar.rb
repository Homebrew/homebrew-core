class Fstar < Formula
  desc "Language with a type system for program verification"
  homepage "https://www.fstar-lang.org/"
  url "https://github.com/FStarLang/FStar.git",
      :tag => "v0.9.2.0",
      :revision => "2a8ce0b3dfbfb9703079aace0d73f2479f0d0ce2"
  revision 1

  head "https://github.com/FStarLang/FStar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a03cf8785ea01a92d9018076f2e9c0583809154facb31998ff96ad0b62ed3f9a" => :el_capitan
    sha256 "8252f9055035425cb329fb53da982319cd7614ffa01bf866f16645e74b759e27" => :yosemite
    sha256 "611406bfa8d13b9a6af24b066e4010b8d96dd260abec933bb215fbb180856f5e" => :mavericks
  end

  depends_on "opam" => :build
  depends_on "gmp" => :build
  depends_on "ocaml" => :recommended
  depends_on "z3" => :recommended

  resource "ocamlfind" do
    url "http://download.camlcity.org/download/findlib-1.5.5.tar.gz"
    sha256 "aafaba4f7453c38347ff5269c6fd4f4c243ae2bceeeb5e10b9dab89329905946"
  end

  resource "batteries" do
    url "https://github.com/ocaml-batteries-team/batteries-included/archive/v2.5.2.tar.gz"
    sha256 "649038b47cdc2b7d4d4331fdb54b1e726212ce904c3472687a86aaa8d6006451"
  end

  resource "zarith" do
    url "https://forge.ocamlcore.org/frs/download.php/1471/zarith-1.3.tgz"
    sha256 "946687d6f032b96ab9db9661d876e39437bff783e0ad473ac463c06259b7a3d7"
  end

  resource "yojson" do
    url "http://mjambon.com/releases/yojson/yojson-1.1.6.tar.gz"
    sha256 "d97497f4d0694f515a9c12708eda2654dddb289b2ed567a377706e62e54c480d"
  end

  def install
    ENV.deparallelize # Not related to F* : OCaml parallelization

    opamroot = buildpath/"opamroot"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--no-setup"
    archives = opamroot/"repo/default/archives"
    modules = []
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      original_name = File.basename(r.url)
      cp r.cached_download, archives/original_name
      modules << "#{r.name}=#{r.version}"
    end

    system "opam", "install", *modules
    system "opam", "config", "exec", "--",
    "make", "-C", "src/ocaml-output/"

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
