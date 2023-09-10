class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.6.5",
      revision: "43f15ea92339cb953b0dcfc6ee883cd0e1a4d9b3"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef445d5feec644a2fc6607a535dfdd764d8b15490633df6b618e46dbf869e68b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2515ac6e65e5ed81c6f356f562617d0cb47a38aa131a1730907ba181311496b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc593efdc956dd9868843c41db6c3203f960884c20cf963a5f7222fa5333fe5c"
    sha256 cellar: :any_skip_relocation, ventura:        "aa84457d1e9e06dfa6a1cf2916a063c6cd18da7ccfdd3bec54cc89c1fd8bb96d"
    sha256 cellar: :any_skip_relocation, monterey:       "70bf17af63f52c2f4d00a35aeb788b7245f2dc42c667f18d22cdd0853b5d97c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e53e49f196e42e8fa0b1bce562b1afd0e872f4ae47120bc9501450c1848c818d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "348cf71a03ddc2ccc76701822bf514ca904cb94577a881a048c710448b4647d2"
  end

  depends_on "go" => :build

  def install
    ENV["GOPRIVATE"] = "buf.build/gen/go"
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]

    system "make", "workspace-init"
    system "go", "build", *std_go_args(ldflags: ldflags), "./flagd/main.go"
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
