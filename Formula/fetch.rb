class Fetch < Formula
  desc "Download assets from a commit, branch, or tag of GitHub repositories"
  homepage "https://www.gruntwork.io/"
  url "https://github.com/gruntwork-io/fetch/archive/v0.4.5.tar.gz"
  sha256 "baa14d521cf0c59668dd5e84451579f48b623e16bb4d3b2254fa3c54b504fc9b"
  license "MIT"
  head "https://github.com/gruntwork-io/fetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e553d2f05c680a1c412ff3bd0df98fc1f4c25a3dab7b44203e8c3bbe8a68f322"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24c8ec351ec9dbc8f71b679e94e1d8930c761b21b3bf4168be0b8d9aab32be0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f10cdef839a155b13ae6ade9db0033303a0651e94958ff950d7585ef76d70b3"
    sha256 cellar: :any_skip_relocation, ventura:        "484b25a8a74dcedaea5d234a8a45e87a40451a07a010bedfa5dbb6718e92863b"
    sha256 cellar: :any_skip_relocation, monterey:       "52f270c33fb1323e965aef897c8067ad993723ce1ab2269df630fc29badef701"
    sha256 cellar: :any_skip_relocation, big_sur:        "121acdd239dfbde5c29565b6719974acfd6bf0793f163773374740a64f243f3a"
    sha256 cellar: :any_skip_relocation, catalina:       "2e13409b0cfbfae80a0aba1f012163529e978090b8eb39dae2feb349e5063201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35d3950442bc4c81b649a7563b2047b991aa13121b42dc47140d915f85ce4420"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=v#{version}")
  end

  test do
    repo_url = "https://github.com/gruntwork-io/fetch"

    assert_match "Downloading release asset SHA256SUMS to SHA256SUMS",
      shell_output("#{bin}/fetch --repo=\"#{repo_url}\" --tag=\"v0.3.10\" --release-asset=\"SHA256SUMS\" . 2>&1")
  end
end
