class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.25.0/dune-3.25.0.tbz"
  sha256 "1d706779fa8405769a1ae667e4baaf4220ed87ec9d8be9d4fea0cf75bd79013b"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d032ecb8f22c52b25d59e7886f0e580f83300729a65f1007f50aa9265a58fd3c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "904b483a2bfa3db1b752de708e0723f8e7cceafa0778e62ad036c090ca1c0837"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dcd0c1f90d6645921487456c96f2281a8c8d04d9594761368fe3bb322b33e054"
    sha256 cellar: :any,                 arm64_linux:       "6577e9f2fd53733e6f546203267919611c51eea669f2ee855464c02decda6b5d"
    sha256 cellar: :any,                 x86_64_linux:      "f428fa1ff88613fdb6edb03c357f2425dfa23232082574880238e0e98610b5f4"
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
