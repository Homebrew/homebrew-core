class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.15.2/dune-3.15.2.tbz"
  sha256 "f959980542ca85909b3f3f8e9be65c2b8a375f3a4e3bd83c7ad7a07f2e077933"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ba7d3fae2af77d8ce2f7cee1ef661ec584639ac7e1995b988358da225acf823"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "181f3da8d22f5ba54838c79412b56a1a1da4555a7799008a4901450f018882fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f766ca1ac5f3d63cb60b20284afc63c2a6de12d96c2a7353645a74076cec893d"
    sha256 cellar: :any_skip_relocation, sonoma:         "606be2bf31aedef412530765f57cdb3ea2fe05a44fff943f770f378900bb263c"
    sha256 cellar: :any_skip_relocation, ventura:        "e80f760f6d3d293c84fa12db2e4be8daab47e1ed71eb14cbda0de349cc770b82"
    sha256 cellar: :any_skip_relocation, monterey:       "a432bdee1bdc92e2d84c74d194ffe7176df2345aaa5168040a89b14a107ff4d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5345f7dd2c6db8065bde582df60a2486428aa18a63f66acf114f6d002063f846"
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
