class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.10.0/dune-3.10.0.tbz"
  sha256 "9ff03384a98a8df79852cc674f0b4738ba8aec17029b6e2eeb514f895e710355"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6db48ee06bc484a9b0beb39010fe53961706f304cc0050116fc005420b471e92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "948b7c795c3ed0096d3400fa57b49162d8391e021d65dfd2a55562965a7ba79e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "847b7f7eea98ecebd446cd6959f2e62bfc5e20bc1c40ebe9d0b5abbfac653f4e"
    sha256 cellar: :any_skip_relocation, ventura:        "a8fa64fb29a36a6b18e487291fc02e279d6cbce4001b9ac5270af610e0075c1c"
    sha256 cellar: :any_skip_relocation, monterey:       "ca4bca74b94248bbf0507c5ad989f93fe9ade574cf8fe3896878e0043f9d1b02"
    sha256 cellar: :any_skip_relocation, big_sur:        "24aec02426d77bb61e64240329917ee36fce95eced614d69f2ca285248245100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17a8ae3880312cff8fb7a8892a4390dd94bdb4a2b62659bb1772835a63f0911f"
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
