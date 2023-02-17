class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.7.0/dune-3.7.0.tbz"
  sha256 "e2d637c9d080318fedf5e71d2a29fb367624f82ac4a26e83df2b3a03550528b8"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "056e89a036f108adad51ac59d710962e727e9b977fc52c341ecf052fdc52efe7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b713d4a81e6e4b195e57961634479ab6ae40b7a3a28d6da28fe48357ee3ac0a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecbe6dcedd569a6353f49c8f169f639c1647f3ea147f3f5530e98c59e5d98c71"
    sha256 cellar: :any_skip_relocation, ventura:        "a8ce7bf2a594c564ea6ca0ce9cd8fc06010f222e59ae45abf13924795a77513d"
    sha256 cellar: :any_skip_relocation, monterey:       "cd535e0ec79893a3374d108be9b1092c8eb4df5bd7cdaa7c42830fa388fb56b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe5b41580324e4e3ac7b8a7dde0f55ae9719fab027781158d09c98e173d4cc72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "049d026257141d75b235713e6346cc5b93d5452c39dfd473f6e2482522ce735c"
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
