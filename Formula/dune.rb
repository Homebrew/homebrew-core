class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.5.0/dune-3.5.0.tbz"
  sha256 "77bd4c6704359fae1969636cfc3cd7a517ba3604819ef89c919c0762b5093610"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "918087c28422910261976d35156b5ab7d934c25440c25c4a65dc6bbb12f10cfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea8f259ab642298f3b3e735a8b7df121fde135692a67bbc1835d07b2ef2a78d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b5ec8711e1063a0ed73e0c2ed13e5f24ee28dc1ca07881b4144b97f4015bf70"
    sha256 cellar: :any_skip_relocation, monterey:       "d91fa1fb8eacd4b408406101d7c33779046ece82834acaf1c46547b0c826c240"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb8efaba38fd8b058444458c9ac157eaea4654a49d58e91a828d0cfc7d11264f"
    sha256 cellar: :any_skip_relocation, catalina:       "177a8e27fbb16f47042906471ebb7a86d3ec1f0c6edbd58346451c9b2ae66ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bcad72709deb5417e4d7a6ebfea69e0041714809c14a7e2bd42faf2186d31c4"
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
