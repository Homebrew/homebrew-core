class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "da81965d48e474df31aea02b613eb5d9696675166cabdc6fb1e6e2e8103f32b5"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c12651e6c9cbc680f6e787336fc2f2af53ccdd09cc7fafc8ee27a9317f507df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c12651e6c9cbc680f6e787336fc2f2af53ccdd09cc7fafc8ee27a9317f507df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3244d3623fc940b32da49370e3b4d78edae09fa66fc336a80dc5a2a6bfca08d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2a7ca0a10912f7e99064fa84f76e4c05a0d1e1aefc026572187c66064872f37"
    sha256 cellar: :any_skip_relocation, ventura:       "74d628872158223d2254232f97bc08654db611958b4269ed5b60aa91d8c3ec50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f218a79d9f3d14172c346ef78f621bfb3dd03f9e5e0e0b9f0199fbb5f6cc6e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dd9fbcb138b56677b3123f7194cb5d13675a5cdd6f8dcfd9a41f218b3b67828"
  end

  depends_on "go" => [:build, :test]
  depends_on "bazel" => :test

  def install
    ldflags = "-s -w -X main.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ibazel"
  end

  test do
    # Write MODULE.bazel with Bazel module dependencies
    (testpath/"MODULE.bazel").write <<~STARLARK
      bazel_dep(name = "rules_go", version = "0.50.1")
      bazel_dep(name = "gazelle", version = "0.40.0")

      # Register the Go SDK extension properly
      go_sdk = use_extension("@rules_go//go:extensions.bzl", "go_sdk")

      # Register the Go SDK installed on the host.
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

    pid = spawn("ibazel", "build", "//:bazel-test")
    out_file = "bazel-bin/bazel-test_/bazel-test"
    sleep 1 until File.exist?(out_file)
    assert_equal "Hi!\n", shell_output(out_file)
  ensure
    Process.kill("TERM", pid)
    sleep 1
    Process.kill("TERM", pid)
  end
end
