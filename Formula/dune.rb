class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.9.1/dune-2.9.1.tbz"
  sha256 "b374feb22b34099ccc6dd32128e18d088ff9a81837952b29f05110b308c09f26"
  license "MIT"
  head "https://github.com/ocaml/dune.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f3fc019e810f9a91b423e700f49983fd6d2f22b32b8c68d99a1cd7a2eee29eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a272b312a8a6292184312151256f94eedd92f31919a0cae103230dc37c9051b3"
    sha256 cellar: :any_skip_relocation, monterey:       "fa7e738c266953ec9cae9265c4b22e6846d2dbccf11dba60b0ecc8d728fa847a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5014448d4ccc8257e3b7edc05ae3d7ee4b7e3b552ea648090e5d2e1d6b11eadc"
    sha256 cellar: :any_skip_relocation, catalina:       "e44461f150faf4ab772c7ecd2ac57bb6d42f48771a7a67b72da1a327ce38119d"
    sha256 cellar: :any_skip_relocation, mojave:         "083e184745d8eac51f5035c3528a045e359cab971bc58ab662615128182acf4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c976d3c7fe424a46b16b3aa0e68f1526ba8acc098ce453b7c958720d1d36a5b"
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
