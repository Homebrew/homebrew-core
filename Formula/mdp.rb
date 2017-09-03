class Mdp < Formula
  desc "Command-line based markdown presentation tool"
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/1.0.10.tar.gz"
  sha256 "7384c1ba32bd8e4b11342570d2144165a60682499b4cb54e50c8eb3164cfabc5"
  head "https://github.com/visit1985/mdp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6771747a2b8bc5d42770188f99060be438cb9d13b5371e14fbf9a147155c62ea" => :sierra
    sha256 "e109dc3235ce7c8525b141d062c8f5483b5fe2e47d12c80f3fce5e74b16d766f" => :el_capitan
    sha256 "9b47182af992b02773445de59b2e9dcb75d18ac72a229d36f019de9847d2f4c1" => :yosemite
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
