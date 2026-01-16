class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "57997600ef4a6d54464d93a1ce8a35ad9b52e94bab823f97d4769d90c80022f4"
  license "Apache-2.0"
  revision 1
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4544f655f82224223c0b83cf38cde6c11afe1c588ac996b9104e4d0750720622"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3992a039deafc18af94a83fdc4d5e68536cef5027719916d8819661a102fc076"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62968ad5c4144b866a2052c9f1ae85cb988a77030f97133094a9756eb1c99ffd"
    sha256 cellar: :any_skip_relocation, sonoma:        "72737fc0b5b26fb966417463d5a3954160dcb2f3d761de0d8b7efab5a17cbbac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "431a6c484ce8541ecddd56d01e0d61f1bad7abcd265618fa7e4dc10c0a9f0f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "046a24ced93a89d3e0ac04d60f976f421993e61c528d434a56cea6041efdb6ad"
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
      bazel_dep(name = "rules_go", version = "0.59.0")

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
