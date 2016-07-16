class GitSecret < Formula
  desc "Bash-tool to store the private data inside a git repo."
  homepage "https://sobolevn.github.io/git-secret/"
  url "https://github.com/sobolevn/git-secret/archive/v0.2.1.tar.gz"
  sha256 "6088c1a149702f6e73b0c40e952c5ece35dbeb3cf5f595e93e16306b1cea32a4"
  head "https://github.com/sobolevn/git-secret.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed4081ea83e6f823c3c032726a1c732748624a6f2204fe21b8405ad8db26a7ec" => :el_capitan
    sha256 "d2b22f2d87bc477fd404d18fd84b919b709aef1f6433d53a7637c97c752ddeb5" => :yosemite
    sha256 "59c2d0dcfe4e00713bb2fe9e04f77ec29ab17b68213be76b20cbe2e908b356d4" => :mavericks
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
