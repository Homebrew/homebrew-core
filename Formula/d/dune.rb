class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.23.1/dune-3.23.1.tbz"
  sha256 "93b4e7157f6ba8feb61cfc5f86008efd2c59037ba78a017d92b4abf30632348f"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdfda8690c4e4f9ef65f295aa019432538631677351457cea290ffb209e7604b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "891759cf47dc1eeb009bee85c529fed28fc6bec1e75b8a95ce4361996a8a8227"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7db54931c325151bb496c95926cdf31fee3eda144f66436050f70140f6ecd262"
    sha256 cellar: :any_skip_relocation, sonoma:        "33273f98b281c7df599ad126cf2ca88c5c35c9d28cca9f78ea31653ae8ebf389"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2e8faeb2af21f6af61f06635d1a38b29d138bbd0cbac88c7e3001d36fba2589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b608cfb0d85e228616809c8da1bf3f35f386b4548be18abd3639c569b59bfc0"
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
