class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.24.1/dune-3.24.1.tbz"
  sha256 "0a8eaa62dfcb945802bcaf9a6f2026ca5228333ee391a1bdedd3e70a3f26ea2c"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5842870884f8e61cd822df1d80985fe209a164747b48f169c149b9aac826501"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ded89f615f2cbb1f4fc782b9be481d38b197a67236506f3699925b49f9acaba3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07d8d46a57a5ab04348c8d6fbafb0d4ecec6f3c42bda2d9cc03b5bff5820ea5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fe2ddddc847873d4caf45bbd536f1bc077c795ddcae0799ea7a7c931f213924"
    sha256 cellar: :any,                 arm64_linux:   "28d4c17ab5d8648dcea7551b89e4a6d071a8de843d1c72e73b42215cfc3c7fea"
    sha256 cellar: :any,                 x86_64_linux:  "4fe6e6e8623cc9ba8ba4c69db9e8902a417dc67859eeaa61cb1be4072a0dca2f"
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
