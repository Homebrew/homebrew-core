class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "ddf899694f17c072822191a1294c6968ab0992c1ce7bbd1318a148fbad497704"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85aa104b2ab763c62cface650a91156449fc0e691c468d4abaa2a1dc2b881ba8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3d7b8c6532959f6e854441396e3f876402fd78592465608eeb5d7a2eaad28cb"
    sha256 cellar: :any_skip_relocation, monterey:       "cea4318a50b7beb03cb0c47d3f92c5a94d2ff2e4d9aa962afa7382571a436ce7"
    sha256 cellar: :any_skip_relocation, big_sur:        "01560735f97f913b043ca37525670db5f64610563e6f69df2be8eecd0345ff84"
    sha256 cellar: :any_skip_relocation, catalina:       "de2cf90a7348bdb3125876338f58de645381d10c6c60a4e768d8d1a6c0e809cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b3b291aa9883c0182bbce3961528e289653116f61a385aabbb3d6dfdb494cb4"
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
