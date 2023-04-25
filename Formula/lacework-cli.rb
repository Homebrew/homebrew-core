class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.17.0",
      revision: "5b75f70b3598b5c5068d404260ec9748b670dfce"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6e724c814c28a529dc9cf3c3e6a82f948c2973deab755124c8eaf68aa7658cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75d12f46c4c6300f1fedfd22c1ac369996c4b4b03ed60d57053f270806249a1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "216242b10c754984f67fbe74bba8862310459ec3c7d247604d17dc24a93e45af"
    sha256 cellar: :any_skip_relocation, ventura:        "5f44ce8d9ea96b4926e346b7e83657f15726ebddd57a4c7304ef7a36d44fbd7a"
    sha256 cellar: :any_skip_relocation, monterey:       "f38de5afec49a8b012537ff45cea4e06c600a695ce1139b3bd59c076b51def24"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd06409c65d98cfad85686e18d730a5dcc54c7fb38949e217b5838b0fa17e1db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adb32c32f8fde6a14005de95dccb69e00aca78c3becaafcddb14c3987199bbe3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
