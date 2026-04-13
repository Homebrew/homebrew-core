class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.22.2/dune-3.22.2.tbz"
  sha256 "c2ccf8bc6b17afa47c450297357496303aa7c8680e329b79d98c68e35013a118"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1c20f4a249e21342f1b63377c53f84ff6003316770c84f205e7d5d81a17e881"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca43bd7fc1168b08782a1f9d36fc3fb271911ee7090dbea9c496422116469bff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0467bfa632950e02395d7bdb947fb49dea413edf1d4bed54e7132327b6d1efd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8c9525e014081e2081dfafaf88d1989726d56ff2df9118bedaf6aadcf32822c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c234619fa6cfab3c910c2454e85e5d58bf36b14f524281078f75e5911375c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf6d6fe8d81eeae699475cba4acf5527e0a1fb7da51e8a2dbfdb572886a5c973"
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
