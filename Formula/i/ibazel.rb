class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "07e8daed80d1c2f4950777eaa0b35cf1f3f4626abf9d020dfffa0459ff22c35a"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c6b63b643a8afd4f0950a7c059514e995e7bcd41e922cac7d8f343ceaee93c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4d9e0bc12b8d2fe8dbee25a211a05a3016c4ad5266881a3e9085236e684807f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26ba1b6829d03e4c81bb1cc24e464c89ae43da2068110faacf90bdb686ff31b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1dcbb2b46dd3f09e012e84f4e2772434cffe62f3756605ccb894ce3e5dc3d36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34a4cc17dea409a51b30ce9cb57e6c4ca50e378bbf15df3cdc0390eda95ff090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e53e9645e32b7eec8720664abdb3f71210b14ffb7721812b1c7ab1589230b1b"
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
      bazel_dep(name = "rules_cc", version = "0.2.16")
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
