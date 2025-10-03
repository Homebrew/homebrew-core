class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.26.10.tar.gz"
  sha256 "621d0b5aaba76c543fb7ede47f9c593276402e07b949dfc946c866fa5bf5ccd4"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eac2fb5f6a66b639c7f3307d904e0c36b7c7e0b9b4cc33df9dce238d340e3c30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0e19cfa3f0a23c82d228261c69daa8ace915b02224179de1c80b00b0e8db8b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecfaf808214c9679e690e1fa0000ee61eb85dbd4b9da272f3975f59a3116d4d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84e84ab933a400083441d3bb63cb94bece942d7d75fc6c070d9a073b77c8dbf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "962448470a89b31e1daac86bf3414a896a25301dd7d6030cfb797ed9f20b526c"
    sha256 cellar: :any_skip_relocation, ventura:       "0c42937d5b4d7d4c53bc2a3260ed9ad15cfefbaeb49eaabc49d7767f2ff84ef1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb553d073a58fa4e9c31728c1076917b06e71cd729b25a5dad009bbbb4b9c25a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "666d9ee54b118c5699dd1463fb795077cd7b05000d1cfca145331642ca7aca86"
  end

  depends_on "go" => [:build, :test]
  depends_on "bazel" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/ibazel"
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/ibazel --help 2>&1")

    # Write MODULE.bazel with Bazel module dependencies
    (testpath/"MODULE.bazel").write <<~STARLARK
      bazel_dep(name = "rules_go", version = "0.57.0")

      # Register brewed go
      go_sdk = use_extension("@rules_go//go:extensions.bzl", "go_sdk")
      go_sdk.host()
    STARLARK

    (testpath/"BUILD.bazel").write <<~STARLARK
      load("@rules_go//go:def.bzl", "go_binary")

      go_binary(
          name = "bazel-test",
          srcs = ["test.go"],
      )
    STARLARK

    (testpath/"test.go").write <<~GO
      package main
      import "fmt"
      func main() {
        fmt.Println("Hi!")
      }
    GO

    pid = spawn bin/"ibazel", "build", "//:bazel-test", "--repo_contents_cache="
    out_file = "bazel-bin/bazel-test_/bazel-test"
    sleep 1 until File.exist?(out_file)
    assert_equal "Hi!\n", shell_output(out_file)
  ensure
    Process.kill("TERM", pid) unless pid.nil?
  end
end
