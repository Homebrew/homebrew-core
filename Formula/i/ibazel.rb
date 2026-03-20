class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "677b07011542b9009238d76f9d1ca2ecf51fbb602dea3a47bdcae1fc4b30a49c"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76469155893798cd824ce34293a59931af1312bb501a4eeb73e3280c58f72559"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dc3a056b9553db0033ea402eef0a5a1e505340ebce18aae191e9d39d9069fb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef5c13dbd4dff3351cb5c6a48bd6b0c8ce832511f698edc9015c3022df5fa798"
    sha256 cellar: :any_skip_relocation, sonoma:        "655a092161bbfbb416ee525ffa71ee0735c1ca8a77d0193bea67fcb968ad423e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91a4d9ab34a6325d4f3cba7f45f811d18c71679381fbc04d87885b3a6ae31ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fbc7c1b506d3cb171104170caa8e7273a44a5e96cb726ea78e0cccdd2b33170"
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
