class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.0.3/fiber-3.0.3.tbz"
  sha256 "d504499a1658f0d99caefbffd7386f2e31d46ceca73167157fe4686c41e5732f"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6310dba5ab1e8e007459525efe49535bb031a568e9a74eeaf136e3b1fd0848a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "787358c6a8ecc686d3505ccaddbf99cb935e39f5307dabf785060edb92016e10"
    sha256 cellar: :any_skip_relocation, monterey:       "7b3b1403375e5869f70aaa9915957f3db34956a3b37dec092acc8e5ad61df2de"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e8340848cc60e5d6f041ada85e6c8954273d567f9b7c8606362985125d86da3"
    sha256 cellar: :any_skip_relocation, catalina:       "102dca3583162dd80e3d8deffcd2012b41ce7111deaa7c1a8c31558e02c0a035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "759481fce1a26285b2100c18a18ded17081e3e32d08b309f2e798ea9e3dec442"
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
