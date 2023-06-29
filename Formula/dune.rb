class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.9.0/dune-3.9.0.tbz"
  sha256 "c4825a9de454aedf450c2db25ac353033e31d326a9d1b4b7a2cd7260639bd544"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df49d15550315872dd35a91867b89d9d502499bcf6a1a3ffb01dccda041fc7b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d371eef0d180cdbe471c8415119aa4495fcabc6e58479dbbba1cf3ca707b269"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "892ed748d1cd59f2e0cbcd146b7978e3b95890d2a53735654dd2586abdce7e4a"
    sha256 cellar: :any_skip_relocation, ventura:        "7ef5c02b42e2dd6c7c67b023e8bf641a62d5e389c8398675b459ba87e78c0f03"
    sha256 cellar: :any_skip_relocation, monterey:       "10067969483b46eb6060248b673f7535357590ae4838be900ff277543f361a0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "62fd10421e306edd1d9829d6e4e40cdd3685f2a54cabf43fc3e6e373b1558152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fb28f54bea793d93b3f9dd86eb6cf5956f5c29ab919d1fb25da934026c6f4e5"
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
