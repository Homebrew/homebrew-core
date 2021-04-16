class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.8.5/dune-2.8.5.tbz"
  sha256 "79011283fb74c7a27eb17ad752efbcc39b39633cbacc8d7be97e8ea869443629"
  license "MIT"
  head "https://github.com/ocaml/dune.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "12e163bf98bb89f2ffb1dca8377fb9451810747ec49010bbf98d865e9557dfeb"
    sha256 cellar: :any_skip_relocation, big_sur:       "ec1d76962b672d6c25a6431332b91073c4bb8b72fd1cfc235f5809f169e92962"
    sha256 cellar: :any_skip_relocation, catalina:      "202f2676e5aabbe4c258c74655dc8a2b0ed1fbb4d216fbea848a4496ddfb432f"
    sha256 cellar: :any_skip_relocation, mojave:        "a1bbc9a63c5dec97bda2dc55ad03ada0e25c17a328102c31f2e1d272ab33062f"
  end

  depends_on "ocaml" => [:build, :test]

  def install
    system "make", "release"
    system "make", "PREFIX=#{prefix}", "install"
    share.install prefix/"man"
    elisp.install Dir[share/"emacs/site-lisp/*"]
  end

  test do
    contents = "bar"
    target_fname = "foo.txt"
    (testpath/"dune").write("(rule (with-stdout-to #{target_fname} (echo #{contents})))")
    system bin/"dune", "build", "foo.txt", "--root", "."
    output = File.read(testpath/"_build/default/#{target_fname}")
    assert_match contents, output
  end
end
