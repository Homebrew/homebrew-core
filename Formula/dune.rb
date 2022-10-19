class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.5.0/dune-3.5.0.tbz"
  sha256 "77bd4c6704359fae1969636cfc3cd7a517ba3604819ef89c919c0762b5093610"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ba632f42cb0122edac6828fa7a3837544d27e81ba7abfd9f094dae8853c880d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bd9d3f7640c04174f982a398f06c1f09a1ec18c791ef21520ecd898bfd78299"
    sha256 cellar: :any_skip_relocation, monterey:       "5f6c4cc376df4bee521b223205be37b0c53e22ad9246df4eb6217995471511cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "419a5d2c0cce823fad6e9a705e5073900c6e07c79e4f12013a93d2760a807629"
    sha256 cellar: :any_skip_relocation, catalina:       "f5b23840ddc903a61c8c6b28501c853ade7725bbb8b51945fe7bc8d22e983506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19539ca2aeb18b116149e150a593aca195286cf52dc11ed86be1a5b1ba5d4527"
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
