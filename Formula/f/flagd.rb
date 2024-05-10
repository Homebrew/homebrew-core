class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.10.2",
      revision: "d58fe3c3ac67843571d8fdc7d04b75996444befd"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a1f467e64c30cda98a3465a500f3ac71a57f0ff7822981d4e1376b2c1fef2ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9936659e47c258e10d8c554916c78d212541e8021e085013aa3e7c94883a8f07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5708f029f1f1c506985801fb8abd9c84e465c8276f4533c6bfe8bd60b4df0b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "16db6911fc8604988b99026dd241074bbab254881ba05d99cf710aa70fb651b7"
    sha256 cellar: :any_skip_relocation, ventura:        "edd510e98ff957940dab17ad7c1cc0bf9a70e633b7c97d0b46dc50cb46c1f02c"
    sha256 cellar: :any_skip_relocation, monterey:       "c315202af515275fa7a9022ca8000d6fb29d9c55d662afc1d58041a3b9368c38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d17a75420b1ba5f3c5a074098eb670d148e9ff96331670dffa0b9afa30bba52"
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
