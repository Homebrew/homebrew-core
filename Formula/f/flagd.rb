class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.10.3",
      revision: "01b50e09f9327a90056f1969598ffc9db780c41a"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e358080506b684d893b68de7a1b2d8c8e95b2ef248503c895ad2d10aa985600"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07f1b2bb9242d735d7c992744f950e763cb29f216504bbf5454dd3d39a90d13d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35e5daa4a62373736f8d3f5b53f00d50ee2d8e9c300c7f2917f382af893818f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "d55a3454d70e75766ab827b3400170da142386d008f5b0dcb04e75a4076f0b74"
    sha256 cellar: :any_skip_relocation, ventura:        "cd5c0f31d40354e5b816d8078b12554bf3b5541a1a6c4c042be1413d46d89828"
    sha256 cellar: :any_skip_relocation, monterey:       "e57bd41168a304884f765c6b8bb83348bb9b838be752a2cded13318ba54635b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19b566726a2a752d902a395530acd2b0ebe88e3180aa65b425154864191b805e"
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
