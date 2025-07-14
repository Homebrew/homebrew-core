class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.19.1/dune-3.19.1.tbz"
  sha256 "a10386f980cda9417d1465466bed50dd2aef9c93b9d06a0f7feeedb0a1541158"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ea4ac9ab5e38040dba9ac5a8c1a34f77b6f203b84c410f21fc3f451f3b09ac4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bcadcddfdee6c254b73a4f2fad14fda6fdb534da5f507454fe4e6ca2a24faa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca3d24fd77d95d99052302ab3089d835b8d3db9d9e4d2cb180ec622c37f8397e"
    sha256 cellar: :any_skip_relocation, sonoma:        "483ed33f937022f7ea1ac4823542d4c5120e9f2342298d4623288ca1535b7218"
    sha256 cellar: :any_skip_relocation, ventura:       "c93c23753ddafc44bbef23d316a014321638f17061c80f73969ce036712bf721"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "801bb57baa9e48f0c9cd16bc11627af0e1921d27f5a0f008c09d004739fb7b7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5f4840194c6dbdf243951d98b59ad331ca8b2bfb2c5c8af000b8d68946ceca3"
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
