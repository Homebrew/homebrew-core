class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.4.4",
      revision: "873c7b37dbbfefa8f6448fb1dec06b2ce40fb02d"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a321592ca2ba26994897af4cc79d61d5a49a8528597c8d8cb87f9d3d0f3e8289"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8b4a682b2251bd1898fa571abb19a0c91fb8f7823ad41505048a995102c0626"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a321592ca2ba26994897af4cc79d61d5a49a8528597c8d8cb87f9d3d0f3e8289"
    sha256 cellar: :any_skip_relocation, ventura:        "040ebd383e68217a9d545ea834f9435abefb4c526fb69ac90c717bec256a299a"
    sha256 cellar: :any_skip_relocation, monterey:       "b9b16291e617545b0114b236a03a7f946fcb58a1dc5f79cf3eaa648ca513310a"
    sha256 cellar: :any_skip_relocation, big_sur:        "040ebd383e68217a9d545ea834f9435abefb4c526fb69ac90c717bec256a299a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d989a7eafcaf8f118baa203b1ccfbabaed351d6a1a9e45052925a351861ac20"
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
