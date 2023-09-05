class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.6.4",
      revision: "ee9116b34715cca0e6794dd01fe9c9eaea693529"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68e79604013116bcf76a137c92059f7e78ef3655dfd1fca65749d995e79a0888"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0703177ba548d71c6d69f0a18e7b31560c66f23d88137dd11cd77553dcb6d993"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6be9556efe1ee4847175a5d6b2bd701d03bf1faa73078450d3d12b2774d02ddc"
    sha256 cellar: :any_skip_relocation, ventura:        "f5f4732316832f66602de00e52111264869d078b6df2898495ca3a1b5bf9b84f"
    sha256 cellar: :any_skip_relocation, monterey:       "163349599a10b5eb61a452770447ee4ea347875262e89ae60516c21348cfac39"
    sha256 cellar: :any_skip_relocation, big_sur:        "33cd026c588ac9409f48eaa23788bd28623e27ac321e173bfd20659c0ed5744c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a33ddd7786e11b81c41e38d8f6df8a6ee5eff5155ae9094016f84bc240193910"
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
