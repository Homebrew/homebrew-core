class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.11.1/dune-3.11.1.tbz"
  sha256 "866f2307adadaf7604f3bf9d98bb4098792baa046953a6726c96c40fc5ed3f71"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9cf33147df77d394daf73899a076ba6bb53a17b36d1bcfdfb58e410ef7aace6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24e686f9f812628b7857ac92d684595e63be6d0b45214a083f215010010249d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6413f2ca824b52c0af43f1cadb891f44ee569d11146a5ee0f3b4cf0b564bdbec"
    sha256 cellar: :any_skip_relocation, sonoma:         "d23e7699606286e37994a103a85acb2036a3454cadcc36cca837788200bdb87b"
    sha256 cellar: :any_skip_relocation, ventura:        "b02d64802cf0a4c8b31d706c3889c1734a017050403d70b9f52cee2b386caaf6"
    sha256 cellar: :any_skip_relocation, monterey:       "677ca15a67ee481be6907a529582aefc923dc2aecc2c58e82af1845ef2e3d3a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a237c8416c7293ade9353fc158a98f74499139ba00a95b87a29b1a7596f0c41e"
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
