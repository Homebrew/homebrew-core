class GitReq < Formula
  desc "Check out merge requests from GitLab/GitHub repositories with ease!"
  homepage "https://arusahni.github.io/git-req/"
  url "https://github.com/arusahni/git-req/archive/v2.1.0.tar.gz"
  sha256 "a7bc8f90230762e93d348dcb22dee93b7c47d07678012976a229950a752a72ff"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match /git-req 2.1.0/, shell_output("#{bin}/git-req --version")
  end
end
