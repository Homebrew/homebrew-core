class Fetch < Formula
  desc "Download assets from a commit, branch, or tag of GitHub repositories"
  homepage "https://www.gruntwork.io/"
  url "https://github.com/gruntwork-io/fetch/archive/v0.3.10.tar.gz"
  sha256 "488102201f69c875489f5d8751f3e2ed14a508849174705b5574925ee3a9dadb"
  license "MIT"
  head "https://github.com/gruntwork-io/fetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0e1d50848e6e2f46a796a642857fc43082b14c0e6d99107426265eed17a518f" => :catalina
    sha256 "e359908f3c023cfb0179a1829641792109beb9815ffbf75e0abb85562f3ef66a" => :mojave
    sha256 "2589550aef609838abb725f0f96589c889884d9c3ad64da3c235cac040549ebd" => :high_sierra
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
