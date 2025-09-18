class Apigeecli < Formula
  desc "Apigee management API command-line interface"
  homepage "https://cloud.google.com/apigee/docs"
  url "https://github.com/apigee/apigeecli/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "5a0950fbef0019c2703532d4b3a7f769614458da6dde71688ddb1d2d36b3c300"
  license "Apache-2.0"
  head "https://github.com/apigee/apigeecli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57c2556b00eb777937d415ea3811dc4513d9720aa802ade9bd3f334242fe1d12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aac81227cb1e280fbf97595c00f672bfd90c1af49d32b3fe150efcda09a91462"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aac81227cb1e280fbf97595c00f672bfd90c1af49d32b3fe150efcda09a91462"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aac81227cb1e280fbf97595c00f672bfd90c1af49d32b3fe150efcda09a91462"
    sha256 cellar: :any_skip_relocation, sonoma:        "01542d3192a28da0937452330807e67b6dfcaac30fff8d95c53183e3fff9c2cf"
    sha256 cellar: :any_skip_relocation, ventura:       "01542d3192a28da0937452330807e67b6dfcaac30fff8d95c53183e3fff9c2cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef51c264c77ede341ef164a5831e554d14c3c229c0e1957546857ef2894f62f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f21d02d20c44c42497d9fda9bd01db92b20c4adeb65f182e7eaae00dcbfb7f7"
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
