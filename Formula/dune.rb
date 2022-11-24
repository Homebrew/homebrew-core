class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.6.1/dune-3.6.1.tbz"
  sha256 "f1d5ac04b7a027f3d549e25cf885ebf7acc135e0291c18e6b43123a799c143ce"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc7ca18795879410361412bdc23ec4ae8e6c3c55cc9b291870b1c378010dff05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3813b72cf17d2942880d1d8cc33f6e3b5a1793fb7f44cbed70e43b7e81ce91eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83a738bd9188651817af6c57cd3e87237a041c30f5ae9d6de94e4b40d88e7c5c"
    sha256 cellar: :any_skip_relocation, ventura:        "cf2c731605abc7424bc5c021cc54a23b627311a5f2e1b46a5d70dda14646f816"
    sha256 cellar: :any_skip_relocation, monterey:       "e2a54dede98302ea2db6013b1faaa2aba3b8fac81651599de1d662bd8eaee3f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ced6ed82ae781a9e52721e64feefe6332dff18f857a2bcbc92d65096ab7180cc"
    sha256 cellar: :any_skip_relocation, catalina:       "23819c33eafc9509dd57b502dbec0e6e8bf0e54a2da48416eb04c273d2caa6aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7498cb744abd964e63d35e4af31e5a6d0702190ef83ac5900924e67f7daed547"
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
