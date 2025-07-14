class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/V0.26.4.tar.gz"
  sha256 "343d0b2d125a34244ff208722b8beb504dd0c97feb9c57107ae6064299a2a9bb"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4290b8456803eb3998aa377f4bd8c141cc5ca7237eb7f28db3f6ee83778ecd7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d515e7fcd696738f688d82c91d0ed5ce01b9ab86d2b4b3ef9396ce20dace0185"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0022a950e5e9674ef2fe87c83e46fbb734feca9ca3e92518549db19eda5918b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c975949513822821429803a5ed96701dc2d74432d8f7f83f797ea17cdeb2ce4b"
    sha256 cellar: :any_skip_relocation, ventura:       "ec5f7a68edb7506f741e05ccf38216addb2922efbe9580d67a0c5a3b3b3c85b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fe65d8353459c10ce34798ba75f0ac40fdc8d5c9bd53b75bab3ad1ac136cfde"
  end

  depends_on "go" => [:build, :test]
  depends_on "bazel" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/ibazel"
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/ibazel --help 2>&1")

    # Write MODULE.bazel with Bazel module dependencies
    (testpath/"MODULE.bazel").write <<~STARLARK
      bazel_dep(name = "rules_go", version = "0.55.1")

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

    pid = spawn bin/"ibazel", "build", "//:bazel-test", "--repo_contents_cache="
    out_file = "bazel-bin/bazel-test_/bazel-test"
    sleep 1 until File.exist?(out_file)
    assert_equal "Hi!\n", shell_output(out_file)
  ensure
    Process.kill("TERM", pid) unless pid.nil?
  end
end
