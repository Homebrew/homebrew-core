class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.9.2",
      revision: "f72faebc0c361deded0c7d89e8ab62dcaf5de111"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5919adee6f19560fe464803765f81764d3cb190ecbf77d7ccedcf3f17f04b2c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2e3f00f2539ad66cd6bd78bfcdd56641e6dd81ea0f8b2330f9adb36bdedb20e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d457e4d06a73300b9a0b92e4510c35daf073108870789d49d4a4659793026154"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf6ac74e812cf751a9a59e84faf31a69be38a77ceb16597c806dc752770bfb9c"
    sha256 cellar: :any_skip_relocation, ventura:        "50aed7d6505eb368d09f74bc5b82958e4c1f5ceb587e431d20027f71d4d783ee"
    sha256 cellar: :any_skip_relocation, monterey:       "4e5578f5bfa387eba687b0bd192407545dc2d7488d1c268b0e46db87ed427446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24a31ea13f84d0c9554ef409b8d3342901f798048e7c7c4e1d8e063a4098b302"
  end

  depends_on "go" => :build

  def install
    ENV["GOPRIVATE"] = "buf.build/gen/go"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]

    system "make", "workspace-init"
    system "go", "build", *std_go_args(ldflags:), "./flagd/main.go"
    generate_completions_from_executable(bin/"flagd", "completion")
  end

  test do
    port = free_port

    begin
      pid = fork do
        exec bin/"flagd", "start", "-f",
            "https://raw.githubusercontent.com/open-feature/flagd/main/config/samples/example_flags.json",
            "-p", port.to_s
      end
      sleep 3

      resolve_boolean_command = <<-BASH
        curl -X POST "localhost:#{port}/schema.v1.Service/ResolveBoolean" -d '{"flagKey":"myBoolFlag","context":{}}' -H "Content-Type: application/json"
      BASH

      expected_output = /true/

      assert_match expected_output, shell_output(resolve_boolean_command)
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
