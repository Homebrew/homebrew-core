class GitSecret < Formula
  desc "Bash-tool to store the private data inside a git repo."
  homepage "https://sobolevn.github.io/git-secret/"
  url "https://github.com/sobolevn/git-secret/archive/v0.2.1.tar.gz"
  sha256 "6088c1a149702f6e73b0c40e952c5ece35dbeb3cf5f595e93e16306b1cea32a4"
  head "https://github.com/sobolevn/git-secret.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4c5c3f99af5aa28bafb32485bd3afd2da4ea5176e63f23992f4b385e3a02bbc" => :el_capitan
    sha256 "3b0e261df46dedb46bd216b92458296bfd54577415eabb0ed7ca9716804dca30" => :yosemite
    sha256 "739bb6915cac64e3f240b1413a5883c4ad910fccc7ea2ebb6010e2fb0df5efca" => :mavericks
  end

  depends_on :gpg => :recommended

  def install
    system "make", "build"
    system "bash", "utils/install.sh", prefix
  end

  test do
    system "git", "init"
    system "git", "secret", "init"
  end
end
