class Apigeecli < Formula
  desc "Apigee management API command-line interface"
  homepage "https://cloud.google.com/apigee/docs"
  url "https://github.com/apigee/apigeecli/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "eed2a51199b7778e2faf1752bb8a8f3bb8d60240f6159152fa9d95f5cfacb534"
  license "Apache-2.0"
  head "https://github.com/apigee/apigeecli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4258ee6b313df32d1a1f89fa22e966a28dc62cae6ccbf607ed870cc85afa73a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4258ee6b313df32d1a1f89fa22e966a28dc62cae6ccbf607ed870cc85afa73a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4258ee6b313df32d1a1f89fa22e966a28dc62cae6ccbf607ed870cc85afa73a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cb1d14ec106a4d6b4da8addee32e69064b9faa21eb5f3caa300d23a0237bfb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bae233defe3cc1a64eb3824123d8551eb2b4840859b5527e0df04b6d3c4ac608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190e83a7bbe8b18c495d04d2a45a5f9e741b62a3120216e72bbc631bbfc3031e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{version}
      -X main.date=#{time.iso8601}
    ]
    gcflags = 'all="-l"'
    system "go", "build", *std_go_args(ldflags:, gcflags:), "./cmd/apigeecli"

    generate_completions_from_executable(bin/"apigeecli", "completion")
  end

  test do
    assert_match "apigeecli version #{version}", shell_output("#{bin}/apigeecli --version")

    ENV["APIGEECLI_DRYRUN"] = "true"
    apigeecli_apis_list = "#{bin}/apigeecli apis list --org=homebrew-test --token='homebrew-test' 2>&1"
    assert_match "Dry run mode enabled! unset APIGEECLI_DRYRUN to disable dry run", shell_output(apigeecli_apis_list)
  end
end
