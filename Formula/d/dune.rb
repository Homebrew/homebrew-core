class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.14.1/dune-3.14.1.tbz"
  sha256 "ea83f9ab24455248ec65288d0f3c4272a5716b61c78f13a87de3d0ac45aed136"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "916570039b1a2498f2d30039e489c6e15313625ae608ab0db06cc457a22cebc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b2a66afaadb6c68d0422e255fa39a1b3106c3cdb440d372ecc9e6a3fe1195f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d44a1077183b5224cbddbb377c085937813f2169b394de80af7666a7a51de157"
    sha256 cellar: :any_skip_relocation, sonoma:         "57d2d85d0f7ee80ce3df2af17c133f09da3ace273a5b2b3bb4685138dc34f963"
    sha256 cellar: :any_skip_relocation, ventura:        "76b2cd1b11ba8b01a0fe4f070160b751a190d5a4a4f75de3f527913e9ec735f0"
    sha256 cellar: :any_skip_relocation, monterey:       "004b33d11c7fd81d192839aec5ac25bb8046f9c4d2705fa8c24cf07c4e7accc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8af8e31d48302cff49bd936dca52195b6b1c91ff6b19f7c4a846f3ccdf5846ff"
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
