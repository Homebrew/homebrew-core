class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.8.0/dune-3.8.0.tbz"
  sha256 "f7e2970bfab99c7766ff1a05deff5ad7f82cb2471abca6f72449572293f5f6b4"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "debeb3055d3f1d6cc15dc8443c2bfaf40199fb44f17a6a9f58c1cfde1ac78fcf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39e1aa169836d4ce140f0c349b6a4043fa674ae36b1dfd34f57c126ecc2584f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "228e0d4a38450558fb535b3e123871ee806dd4aa67c5bc63c6931ec6e6207880"
    sha256 cellar: :any_skip_relocation, ventura:        "e8659cf871dfd57b43af551ac10e3cedf20e6887d66849d68bb21eea569bfd7a"
    sha256 cellar: :any_skip_relocation, monterey:       "27863a13892849c37a494f25e6710d1de86c1b75160a67bca5a897b7d0729a6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad7e481ba853b4a80fc0d501fc4b8c75cce9cce79303fbd46ee25abbeffc31d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46c72eb5867fcfb3881826f2d6672de0929c172f46b8cbd8cdbdcb827981639e"
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
