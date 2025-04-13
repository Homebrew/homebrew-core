class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.18.0/dune-3.18.0.tbz"
  sha256 "b7450daeadc3786f6d229f1b8be98a3de1d8d7017446d8c43a3940aa37db2ffb"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "107a16de2809d2e4ec19e4adcefcdb54a5d3649388f2d032c0c6c89745688554"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d7211821c31f6b50a9d5ded370538bd276813e154515cbfcd6f9ec6ed886972"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e37936cec4438b8f564219dba25c3da924c469f931bcb5282dfb773279e16f9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a87317aba396c813151aa9e8d1bbb7bc6357470a17427520529b4d5fbe32243"
    sha256 cellar: :any_skip_relocation, ventura:       "5c17094f683f8d67e3d6c6c61a80dc014433b494bbe542a24a2d8848a9304fa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c8a73432c191409f457f8c79ffe0e51bfc1b3ab6333e7ddfedf3fe8a39f6195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9b50efdbdf34eac6d8ac2a07eda197b881e66de7f9e7031a69e3a49615c345f"
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
