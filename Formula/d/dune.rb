class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.11.0/dune-3.11.0.tbz"
  sha256 "1b9c7d7e134a8d3a9d715613f02910ecf31167df1ba226ede921a5fa7b0d6513"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f127466fcf5dfeaa4d48d5dbc4549f3abdad2e0af7ea3cc0a887653436d583b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed3503c1e85e84fcb7eb77162efd6fe4419be96b324feae6f463cf9289c4e6df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da0dc85a7e68833b490657a2e3236347dc1e3a91462a616a42619cc0a8318636"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ce3c73860612f098191d35c03eb8bbfce35f4b73a63cb15987cc984d4b2c7ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9dee7a78876904c65c5bc004d5ea490ecd1fa8379fa44330a0ecdb2bc38dc92"
    sha256 cellar: :any_skip_relocation, ventura:        "f43ae902a34fccc196adb1154cd41f10fc4dcdd0c83ea7779cd4dbe965ab5783"
    sha256 cellar: :any_skip_relocation, monterey:       "13675bacc0929fb53822bf7dbad7f2f32fc80096b01d65e037c5e5ebacd37913"
    sha256 cellar: :any_skip_relocation, big_sur:        "08d74b89790b099005cc4bea040bd63e5206686de14efa11ea64664d15033a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "139c74dceb99623cc93d69be0b5760b151e3f9a68e1b1c470cc9d0724368ae01"
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
