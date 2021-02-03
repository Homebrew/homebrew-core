class Fetch < Formula
  desc "Download assets from a commit, branch, or tag of GitHub repositories"
  homepage "https://www.gruntwork.io/"
  url "https://github.com/gruntwork-io/fetch/archive/v0.3.14.tar.gz"
  sha256 "af6513aadf2105bb2355c3b6acc74fa2b12df12d963292750df197b879c32868"
  license "MIT"
  head "https://github.com/gruntwork-io/fetch.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "678a2b7373830d0dc64ca9a335706f0638c810298094b8ceb2eb7dff0db973f4"
    sha256 cellar: :any_skip_relocation, big_sur:       "61109bd1f647acef7cb68a09cfd4a8fa04053dfff90a3be32deb8027ee6b06f7"
    sha256 cellar: :any_skip_relocation, catalina:      "194dba2e7ccdaf0691b3b17146ac1ab77088251823b143fe9cbcf3d790ca2a59"
    sha256 cellar: :any_skip_relocation, mojave:        "544a2cc87fed7545d1e220954b445a6519c47662cd41b64c9ff8ec9f0fd0742b"
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
