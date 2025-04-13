class CloudfoundryCli < Formula
  desc "Official command-line client for Cloud Foundry"
  homepage "https://docs.cloudfoundry.org/cf-cli"
  url "https://github.com/cloudfoundry/cli/archive/refs/tags/v8.13.0.tar.gz"
  sha256 "13c344e0add8876de103e536b383a837f679881813441d985f7503e3126f8de4"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "227ab5412bb0b0f63ee645b4e40c810e16d6fa7a8a930ab0982548fb3ba2c7f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "227ab5412bb0b0f63ee645b4e40c810e16d6fa7a8a930ab0982548fb3ba2c7f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "227ab5412bb0b0f63ee645b4e40c810e16d6fa7a8a930ab0982548fb3ba2c7f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "455258ce54c56fe5a6c055c6fedc015be8c1a72c5845078c6c4c7bb399ef5204"
    sha256 cellar: :any_skip_relocation, ventura:       "455258ce54c56fe5a6c055c6fedc015be8c1a72c5845078c6c4c7bb399ef5204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9651545bc5f58f839a4b26f585feffb7d6f3852ad5430fcf54aa201f20b850be"
  end

  depends_on "go" => :build

  conflicts_with "cf", because: "both install `cf` binaries"

  def install
    ldflags = %W[
      -s -w
      -X code.cloudfoundry.org/cli/version.binaryVersion=#{version}
      -X code.cloudfoundry.org/cli/version.binarySHA=#{tap.user}
      -X code.cloudfoundry.org/cli/version.binaryBuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf --version")

    expected = OS.linux? ? "Request error" : "lookup brew: no such host"
    assert_match expected, shell_output("#{bin}/cf login -a brew 2>&1", 1)
  end
end
