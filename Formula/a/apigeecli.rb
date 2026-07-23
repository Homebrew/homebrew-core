class Apigeecli < Formula
  desc "Apigee management API command-line interface"
  homepage "https://cloud.google.com/apigee/docs"
  url "https://github.com/apigee/apigeecli/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "9b9fc5f70732b08d21165bbd2c39cbb88f73c700480a8fda8bc52c6b2da9cff0"
  license "Apache-2.0"
  head "https://github.com/apigee/apigeecli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a698c837530a57d10f1056d0b1f7d2d64dfde1992b585ea16ad116238c53f12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a698c837530a57d10f1056d0b1f7d2d64dfde1992b585ea16ad116238c53f12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a698c837530a57d10f1056d0b1f7d2d64dfde1992b585ea16ad116238c53f12"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9193afb8ac3b185cd798dccfd4bd8e0f7c4c2e6a9ea1ee0875aa3d04304d0d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63c76db440f9ff3f6e9823694f891b44fb08099e10bedbbc1a4470051c20f9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea511dedf463a3f405b822f3cca9ce2f1a70d5420ab06699c58a85a33a13ac16"
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

    generate_completions_from_executable(bin/"apigeecli", shell_parameter_format: :cobra)
  end

  test do
    assert_match "apigeecli version #{version}", shell_output("#{bin}/apigeecli --version")

    ENV["APIGEECLI_DRYRUN"] = "true"
    apigeecli_apis_list = "#{bin}/apigeecli apis list --org=homebrew-test --token='homebrew-test' 2>&1"
    assert_match "Dry run mode enabled! unset APIGEECLI_DRYRUN to disable dry run", shell_output(apigeecli_apis_list)
  end
end
