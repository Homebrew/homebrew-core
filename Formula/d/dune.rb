class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.19.0/dune-3.19.0.tbz"
  sha256 "d2f617dfd34f7d882f4181a22e359bb90b46669ed87b2650eb842f0532fc696c"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a1b7e2300fe26841bd14a697b73f12afa7e2f78706d2bf85048f04d97a1840d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d21f92db4dce7ad3ba0dc3ecb76b37b95dac710a62a380a352367aaa1a0dae5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "329d3c71f20f03caa0d03b7db454583d9199e27abea09ce7b48a9a7d4fe04009"
    sha256 cellar: :any_skip_relocation, sonoma:        "8090fd3e5ded794e982d93cf1951adccab835f2a94827cf02cf7d8ba1041e627"
    sha256 cellar: :any_skip_relocation, ventura:       "b6bba713e13d813318b74f9211e7ab80ddf2556f0a61fa7e6f20da2f0188c85a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c9e52db05bc9667a2d23c33d832dd226cb835fcb5a5b59c871679615287e299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2de6db816dbebd74720177f2ef06c33d0712ed7f82576db489601259259c583"
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
