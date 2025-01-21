class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.17.1/dune-3.17.1.tbz"
  sha256 "6b9ee5ed051379a69ca45173ac6c5deb56b44a1c16e30b7c371343303d835ac6"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbe712230ebb0b40c9e8b1ef98b8dc71833486de4b45a4a7a85b96b96dde477e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ca9c2522a72cea646d27a6bc31a6107b572ca25f51282eb67a48dc19d5782fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b96067281833c3383f0fae1950e42ecd7d2f805bd688f9985c51e58452cf6dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "eea07e9f1a4c83eee7e6294f5956f90eb59b9a06a3595aae12cd8d3f7e53fa1c"
    sha256 cellar: :any_skip_relocation, ventura:       "4b1bc4b25cf3c392df87a4fdffe2c85bd8edd4742ec55a8175d22173bf1f38a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5a6a2519c0a84ac69567bcfc5abeaad4e036831b510bf0ae6ead5e5fa6e722d"
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
