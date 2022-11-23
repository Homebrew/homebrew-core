class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "235381f6720b9ccb81bfa95990ba5ee84e6749baecdc3be03c6a36c56c4f8a99"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b80ffd3b4f04377c66491c30fb45e9da14de9542327f06bf209321e21a35dc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20975c250c46d8b57165cece3e31f812d9b0a5c867151d2abae4f2bb43699c95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f5f4f36498af32ec95c01aac4ae977a0118e928895173fa4f537fea57fe9798"
    sha256 cellar: :any_skip_relocation, ventura:        "34fbf7f0fd4f3461b9b39bdfbb01681707da444d37353103452aed3df315242e"
    sha256 cellar: :any_skip_relocation, monterey:       "81077ecb98dab486d2ff2ace711f44996dd4aae889da5a22f0e5e9c11bb24b37"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cfb9f3e08f22084f4e4d1536762da2e0b80b7040de9a7af1970d5685741b578"
    sha256 cellar: :any_skip_relocation, catalina:       "7b6498895167c1fd93d52d00e9ee1804ea0884da81e8d011a7e2ed29062dc7e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4177b40164310036397a3e32ac7b4fb4500b488e025096fba71a48a47efed4d9"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd/test-reporter"
  end

  test do
    binary = bin/"buildpulse-test-reporter"
    assert_match version.to_s, shell_output("#{binary} --version")

    fake_dir = "im-not-real"
    assert_match "Received args: #{fake_dir}", shell_output("#{binary} submit #{fake_dir}", 1)
  end
end
