class ChainBench < Formula
  desc "Software supply chain auditing tool based on CIS benchmark"
  homepage "https://github.com/aquasecurity/chain-bench"
  url "https://github.com/aquasecurity/chain-bench/archive/v0.1.7.tar.gz"
  sha256 "bc42551bde3ce61500d0eea3f4443e29bc2c5d86b1f01e87f929c46ce308ca9a"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/chain-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c86422a1ddd597f84353351f5c77e3ba2f798552d4b4ae30ab1a2f2de612145d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35983e5f6f4c054c2d2c517cb6465994097e0353575f0739f44f693729c96b02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2fdcc6689aad1a4423cb5ef265694759562854410bd41bfcaae5530ed26b0f7"
    sha256 cellar: :any_skip_relocation, ventura:        "a0bf6c469e4c139d58665ad3da59a7fbbdeacc1d8fa14a49dacac4f43b5c7596"
    sha256 cellar: :any_skip_relocation, monterey:       "988a2f425eb35a050aca2a354cfd1f2552b31270e295e488866f7534fb4cc470"
    sha256 cellar: :any_skip_relocation, big_sur:        "eaf5fda8e47568cf818eb9f07b586b04b7973c8dac9290fc89a6280d3cdd8909"
    sha256 cellar: :any_skip_relocation, catalina:       "3ba54ed8c1422ae0f3c9067f3ad898af922b94caa6a0a8ddb60e2a8ba829d746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39585a1d4be722d0b0588e7403f1491c919fb06b95f55a82b4246a1879b2c24b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/chain-bench"

    generate_completions_from_executable(bin/"chain-bench", "completion")
  end

  test do
    repo_url = "https://github.com/Homebrew/homebrew-core"
    assert_match "Fetch Starting", shell_output("#{bin}/chain-bench scan --repository-url #{repo_url}")

    assert_match version.to_s, shell_output("#{bin}/chain-bench --version")
  end
end
