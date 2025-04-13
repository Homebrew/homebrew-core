class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "8006002a0899470f782a965724ebb3ab19fd48873cb50ce7722d474710d22995"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5fa7bdd1ab10afc961caea3a0e669e917f1af32c315ddfd24d95accc4febf4bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "210c03916b8e4ec0d2172f9b7a4f52ca5447a81e6517979609b0d958d8b4fcc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5446e9c167595aa6e31a558b0ba82d5505d58cd07f6168dac76474f57bf4417a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04e6c06647c7d0dc90497ffaf4cffa437f41259e53070fee8bac6cf465941a52"
    sha256 cellar: :any_skip_relocation, sonoma:         "17a887a1df832df6cb9d37705395b962cae39a22c859387be3f34864cad7d54e"
    sha256 cellar: :any_skip_relocation, ventura:        "7a96a8f6df56003b66454334f86760a0f151d4182e2a3884ffcfdde4246dc297"
    sha256 cellar: :any_skip_relocation, monterey:       "1da2717a31beea4f4a469d611beb9e0f568da7ba85b8dd2783850e16e1969c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34af7cf6797de10a49d6f03cc1b9a4899715ec223fe0bfe7adc02a41e2386d43"
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
