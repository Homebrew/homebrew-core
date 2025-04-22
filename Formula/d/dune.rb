class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.18.1/dune-3.18.1.tbz"
  sha256 "5fa1e348f0cb24eed4ed93ceff0f768064c87078ceb008f6756d521bfceeea9e"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9df9caa9e4274d905f34b5c011cda3b26d91fda5adbf67400c8edcab2c6929f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1753b205110110033d5a01229ba83bc8cfc6582d9f3b28c81e87a9a30f48f873"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88cb88fe8b51c46a057f923a5a962e47ab8019d3b440dab48181bf36d9774ffa"
    sha256 cellar: :any_skip_relocation, sonoma:        "02e99f2533c3d855b6b4b2bd2639a5d20376c2eb48a075bf7aaa090b3f758ef4"
    sha256 cellar: :any_skip_relocation, ventura:       "e56a6bb0ca2922f47ee173cb9f11a4ec25b2fc2f8a56732f35cf72584da4dafd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddd035c875c9152e8294bd4768a5553e2cabbff09d3c4a4984eaa63330d626a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfac426aaab600963dade08c0a1a5c4fa0fd188829c14f331c7538e505b4fd63"
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
