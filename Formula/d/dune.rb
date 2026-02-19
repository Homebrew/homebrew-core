class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.21.1/dune-3.21.1.tbz"
  sha256 "84f7a82c6d80a7124f3847e9a489e80cfbeafb7bed3573ac01286ef56fd08d94"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b252fd38dd6e83bf949e8bcfdfbf528a944e11cfed72a04012c1d7318daf2212"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0652e827f1c0b3bd4ad11de136c457a478622b33a2a3bd3269eb0757ddef055"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f45187116bf84220d0b367c90f4f050af934361bcf6f46c9795469b219af6cf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fe1f11d7fd73c6221598e8284ccd3bdf34dfb25c16fa0f4d6ef8072adb38927"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63826c690a019fe8e38b331bc566ec9bead61f2d5079e8077c85df2d08504489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b71e0a5a1e5960164dbaa7825e9bd8e23f875774f11b707723fb44373fdb35e"
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
