class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.16.0/dune-3.16.0.tbz"
  sha256 "5481dde7918ca3121e02c34d74339f734b32d5883efb8c1b8056471e74f9bda6"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "95b1b8623c6e134be8c07660eee13bf0534b63fbac3cc520273885ceab36cb30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c705387f96692b7075e6d981be85588c43847eb9716072d2a92c15aa623b5ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3ebc5cbac423f50a79db2fb9b3586b0e77731e204845d9c2f9190fd97d13b55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbc76d1cbabab2e4e25972125cf3c9d5fa3af0d8ee663d263b303c7cd81dc99c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5a6960e4b995ba8428ffea1ee1e8a7d99098b809065e956ccdacce9475e4d10"
    sha256 cellar: :any_skip_relocation, ventura:        "eb241573ffc403ac3b86d65586ed0540b27f7a722a8c9a26990fd2819599d7e5"
    sha256 cellar: :any_skip_relocation, monterey:       "23ff9c55507ab3a8262648d47fddb9b34ac8b37a01eee3d0fe18ba3eb7c57073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d4dc2923b46d80e72e55038ad220bd9e9418d4f31bca82c1c76a32503590840"
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
