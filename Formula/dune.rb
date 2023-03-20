class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.7.0/dune-3.7.0.tbz"
  sha256 "e2d637c9d080318fedf5e71d2a29fb367624f82ac4a26e83df2b3a03550528b8"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "498f7ad03ee20f842e3f6344b4e6debcfc6ef04c1ef6fe87ea0997e63ceaac43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6be86613c3a8913aee821840fc6cf2cebc0cb7469b23713e2dbf50c243972998"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f784af06ccbde08bd918bce95893a190b3350f7ff26f88840544a692210112a0"
    sha256 cellar: :any_skip_relocation, ventura:        "7b7ccbae5e65801dbfe0d6c2f885a2e496135c9776a2b52b5d56abb2ec76fbf1"
    sha256 cellar: :any_skip_relocation, monterey:       "625f58e3ed9e69ea0cbc76ca0ac5dca04506170093380cedf7e38810f5174fae"
    sha256 cellar: :any_skip_relocation, big_sur:        "43885811df77afa90c536a3dc447a7dbfcc0761414ed0fa44f5afffb1a2cbe63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2708e8a2d1d9688218c89450d31045e9835b44bcde95cc1de18820dbf76936c0"
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
