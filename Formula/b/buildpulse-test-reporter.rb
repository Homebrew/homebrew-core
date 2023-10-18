class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "fc9a01cb2666bf4c23e7883d870e00304d1090261752c1010294f8a5a5a42915"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "579bcdd2bed560578f78bddfd7f469aebc3c633c1181635190f1e0170352ff99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "801f783e1e66b87b360ae49212f77f269236ed1026c65b44c3826fc471e715b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28f13d4c2f408098709e37c96f46025cf3eb030bb1f58f09c8bf7adb637d8495"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "308adeaaa4a3b0354719b3978a903bfb11aa782f623ffd01820791a18ff9a21d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e167782bcab7f3669c96ebcc9ed56ea1305db7582ad5cf5291d5dfaf33345ea"
    sha256 cellar: :any_skip_relocation, ventura:        "cffb070a2562c7825c1e1a4f0ae1e32f9683ceb10f8f1b6e8e8530510694ba0d"
    sha256 cellar: :any_skip_relocation, monterey:       "85c41b9834340ab17512c075b7bd7133ca8592e48d83671277ff883ee80a5f16"
    sha256 cellar: :any_skip_relocation, big_sur:        "821e2c6fd14442968c6cc64c0387c0192c37b9ae03f46a3fa8cc7331cfccae2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6f972f1ebd1185f9f803f2611df847b2103f49be114f3ab8a19336bed3ba4fc"
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
