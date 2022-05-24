class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.2.0/chrome-trace-3.2.0.tbz"
  sha256 "bd1fbce6ae79ed1eb26fa89bb2e2e23978afceb3f53f5578cf1bdab08a1ad5bc"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a092d71e2a557640c5eb2536626fcce8bd3266ec62b63b7154c9831045709c58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b7d11b76354ab68c5bbd3163f4ba52c26071ad742cc4cf8ffb9f958a5c53589"
    sha256 cellar: :any_skip_relocation, monterey:       "bda67220b7c34bc6b30c99d9b3cf6054f28c23111243e58af96e050300c31526"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebcbb0e30e5764f16dc659c8dfe939186c9cf7ead5229cc47c498d8533625907"
    sha256 cellar: :any_skip_relocation, catalina:       "c2d9d4af81f9599631fc7060641ddc18e039b2887e6eee7f4893d7ab3031bda7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "071d66e8406dfba0d2e48ce4a8f8402ddbf9d71df5f8246dee5e0865effc2442"
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
