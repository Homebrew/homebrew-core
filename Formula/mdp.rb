class Mdp < Formula
  desc "Command-line based markdown presentation tool"
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/1.0.12.tar.gz"
  sha256 "9faca0245babd54aa47cbbb72c14244ca9a9a84f63021a679078041da4f6e98b"
  head "https://github.com/visit1985/mdp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6dda2a53ef5ef16249ced6daf96de3bab9fd742106fec8b7eeb23f954c70e5f" => :high_sierra
    sha256 "17c2e33bb7953fe8cbdfb1e8a70c9d5f0b3346023d9dd4670ad8df82fb5c7fcd" => :sierra
    sha256 "5c54089e38d0cb93bc24cc39fdb94148539955b6d682707dd263aef039cf15c8" => :el_capitan
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "sample.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdp -v")
  end
end
