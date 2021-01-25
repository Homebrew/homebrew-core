class Fetch < Formula
  desc "Download assets from a commit, branch, or tag of GitHub repositories"
  homepage "https://www.gruntwork.io/"
  url "https://github.com/gruntwork-io/fetch/archive/v0.3.12.tar.gz"
  sha256 "949e7ba4123c358d961a0bef7a389f07d1021d9d6e33b205dbe91be4a87bf586"
  license "MIT"
  head "https://github.com/gruntwork-io/fetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b51881c031a1a69f6c5a4e71302328b09df6486ab277124318f261523cae431" => :big_sur
    sha256 "280a2436bf5fa3bdfe399cbfb21300c65d5a0fe049c7d95f52e099f4abc1902f" => :arm64_big_sur
    sha256 "5c9e2f5f27cc12d38717073b082b31c3ad50b9cc3a40555211ef3385a27b0706" => :catalina
    sha256 "92d29770f6071eb78017423cb89f7177bee95e176e0263e70ccb3e9ccbccd393" => :mojave
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
