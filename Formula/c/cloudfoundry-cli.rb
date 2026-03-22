class CloudfoundryCli < Formula
  desc "Official command-line client for Cloud Foundry"
  homepage "https://docs.cloudfoundry.org/cf-cli"
  url "https://github.com/cloudfoundry/cli/archive/refs/tags/v8.18.0.tar.gz"
  sha256 "33cbaa5b45f3cba52ed7842a84fd1c462de4fa334f6e09929eb0c7b4420f7d2e"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b61decccbf35024e3257bc139377ff3a310cc0eac449200bca9ce662697591d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b61decccbf35024e3257bc139377ff3a310cc0eac449200bca9ce662697591d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b61decccbf35024e3257bc139377ff3a310cc0eac449200bca9ce662697591d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b487d3d8ed11eaca1defe7c3151ad7352812b6f1fef8cef09c34387f99f12344"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87092cf4cf85b8264f6d0767a0dc0cebfb69a33f4eb06ddcffbf4d639e1a0616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b139461c0739a4b9c0ec054df2bbce366f88887c40e7182e0c01a8ae3910d208"
  end

  depends_on "go" => :build

  conflicts_with "cf", because: "both install `cf` binaries"

  def install
    ldflags = %W[
      -s -w
      -X code.cloudfoundry.org/cli/v8/version.binaryVersion=#{version}
      -X code.cloudfoundry.org/cli/v8/version.binarySHA=#{tap.user}
      -X code.cloudfoundry.org/cli/v8/version.binaryBuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf --version")

    expected = OS.linux? ? "Request error" : "lookup brew: no such host"
    assert_match expected, shell_output("#{bin}/cf login -a brew 2>&1", 1)
  end
end
