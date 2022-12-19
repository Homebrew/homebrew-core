class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "30f67a107c7a436f09e94b901f8377d15b28cafe3f8497910b824712084ee182"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51d2a8ba6507166b5f7f31092ae4bf1cb32b837b4f5045faedd0a1aef779320e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81815c0a88b99f958058dcfc351012adce58e43b3565a6063ce823466b8e9055"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bd54fa43f52d406e7b56cf5e4e9a56b5400fb0933aeec59c24777321020af2b"
    sha256 cellar: :any_skip_relocation, ventura:        "4881c797b3de154e57c77d53a94e09db241f217986f0bc771ba9df9d43eca75d"
    sha256 cellar: :any_skip_relocation, monterey:       "abb017769bc299a312f132037c949ba5acc478d4362b131110ac513ccecc583b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c57ca3113375d8fa43c9fbbaaaec3eea3fcd0e03ac60547f1ab2b094c5f7ff5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41910a94da8e2bdf1fd9b7198e8fec2470dc94bb1a55e1becaa4d5ca6b6cc98e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update-ca 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
