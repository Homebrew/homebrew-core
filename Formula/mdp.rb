class Mdp < Formula
  desc "Command-line based markdown presentation tool"
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/1.0.12.tar.gz"
  sha256 "9faca0245babd54aa47cbbb72c14244ca9a9a84f63021a679078041da4f6e98b"
  head "https://github.com/visit1985/mdp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "847efa4b5df6c24c768a3f13a312b3ece5f99e3ceff8d293c42b2c241e918c35" => :high_sierra
    sha256 "d23b853ad13d7557f7156314df76bf4efcbd40c6cb0afd4ac4d59cb5803bc1b8" => :sierra
    sha256 "d2db9becc3573a975c8da120dcb62dcfc3cbb0f146850744dab3fda4917fd693" => :el_capitan
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
