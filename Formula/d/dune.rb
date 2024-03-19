class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.14.2/dune-3.14.2.tbz"
  sha256 "e80867cb362b2749d9d9e0cbab2982f98af1daf4459b81164ca0aac6b4e6ace1"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d12d3c16e273a3f4f70d4c60af5ebc14c7e9f15c5d957e1c7d1196b16562e61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbc6762966c90a624d5299e066aab2b9a116b098bcabcb289d7b9dce2c108e53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57481d4fa17450c893a9e304d06b36a0d0f86e3b543e684890678397fdf92615"
    sha256 cellar: :any_skip_relocation, sonoma:         "579ab21141afd4a86d2a49f3ed05517833f7807ae4e4bfa18d5ceee9689fe469"
    sha256 cellar: :any_skip_relocation, ventura:        "879eb92e15aee8b058371ade3e37e236f5abaf2c2052a4cf5bb051c5135e4a0c"
    sha256 cellar: :any_skip_relocation, monterey:       "43e1cce2f17f77cb9f4f786f39d526c79e1a3e9e7a06a5101139e4d0282fac6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42c61a727b5930fbc367d00d038269aa6d63f4831b21a2c8579aa83b1c62177d"
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
