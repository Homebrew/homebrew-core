class H2spec < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/summerwind/h2spec"
  url "https://github.com/summerwind/h2spec.git",
    tag:      "v2.6.0",
    revision: "70ac2294010887f48b18e2d64f5cccd48421fad1"
  license "MIT"
  head "https://github.com/summerwind/h2spec.git"

  depends_on "go" => :build

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp
    ldflags = %W[
      -s -w
      -X main.VERSION=#{version}
      -X main.COMMIT=#{commit}
    ]
    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" "), "./cmd/h2spec"
  end

  test do
    assert_match "1 tests, 0 passed, 0 skipped, 1 failed",
      shell_output("#{bin}/h2spec http2/6.3/1 -h httpbin.org 2>&1", 1)

    assert_match "connect: connection refused",
      shell_output("#{bin}/h2spec http2/6.3/1 2>&1", 1)
  end
end
