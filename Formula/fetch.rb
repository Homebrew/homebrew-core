class Fetch < Formula
  desc "Download assets from a commit, branch, or tag of GitHub repositories"
  homepage "https://www.gruntwork.io/"
  url "https://github.com/gruntwork-io/fetch/archive/v0.3.12.tar.gz"
  sha256 "949e7ba4123c358d961a0bef7a389f07d1021d9d6e33b205dbe91be4a87bf586"
  license "MIT"
  head "https://github.com/gruntwork-io/fetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a106ac8e98524efb62d5094a3b06f6b0883ef95f1affff388ae8656f84fcfa7" => :big_sur
    sha256 "7af2df6cedb0fa7d6e0565fef2667a5bd2a4434e1705b6c3555d0e7950c08249" => :arm64_big_sur
    sha256 "4ff8bb89d5ce13392ed8f96d7da747eaacb842fa5829d799aa469c15197e8caf" => :catalina
    sha256 "e2c9c3b2aa915880cda1e940763d6adc09bca9de097003a06c2b900b24616ef8" => :mojave
    sha256 "47a73e9563c765b488948574e9ef935fb3a2f8db8f2c98b4997829d877a233ca" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    repo_url = "https://github.com/gruntwork-io/fetch"

    assert_match "Downloading release asset SHA256SUMS to SHA256SUMS",
      shell_output("#{bin}/fetch --repo=\"#{repo_url}\" --tag=\"v0.3.10\" --release-asset=\"SHA256SUMS\" . 2>1&")
  end
end
