class Ott < Formula
  desc "Tool for writing definitions of programming languages and calculi"
  homepage "https://www.cl.cam.ac.uk/~pes20/ott/"
  url "https://github.com/ott-lang/ott/archive/refs/tags/0.34.tar.gz"
  sha256 "c14899fb9f9627f96fcde784829b53c014f4cd2e7633a697ac485ecb9ab8abd6"
  license "BSD-3-Clause"
  head "https://github.com/ott-lang/ott.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f26fa61413c7091e27399e1d844a24ac94b69f00805eb6b3f6d9fcd416d90839"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d045d9324681cbb59888db4b0f47cde465b9777faa3ead91b4dafc748698a55a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e64b4f53bc4b32c5c2300ca5e6b4ddc9f336cfc10e9b40561c00433758fd9a6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da33fd1e6bfc151dbc8f8f1ed08e086715900c038b29537624944a36e1fb3b52"
    sha256 cellar: :any_skip_relocation, sonoma:        "8271dd4f6d13603b7353203cbbe021f2fb6359356a6fed14747d9c6761eaa477"
    sha256 cellar: :any_skip_relocation, ventura:       "606c6ecd10fad0b508c32072a518e8ff135d9a12dc7dce01e95dba94b21154d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdcc901f3f3198e2fdedd4d897ba24e554f88a208efdbbe47b87eaaa06041931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73f293a7ca9b84a8c105e9e5106176695c3207f4e92b98890ba72652dbec2e81"
  end

  depends_on "gmp" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build

  def install
    ENV["OPAMROOT"] = opamroot = buildpath/".opam"
    ENV["OPAMYES"] = "1"

    # Work around https://github.com/ocaml/ocamlfind/issues/107 when `coq` is installed in build environment
    ENV.prepend_path "OCAMLPATH", opamroot/"ocaml-system/lib" if Formula["coq"].any_version_installed?

    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    system "opam", "install", ".", "--deps-only", "--yes", "--no-depexts"
    system "opam", "exec", "--", "make", "world"

    bin.install "bin/ott"
    pkgshare.install "examples"
    elisp.install "emacs/ott-mode.el"
  end

  test do
    system bin/"ott", "-i", pkgshare/"examples/peterson_caml.ott",
      "-o", "peterson_caml.tex", "-o", "peterson_caml.v"
  end
end
