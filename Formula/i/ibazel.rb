class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "6db42edec7969b2688166d2e82945502b5d8043207ddebb834db21d614dfd244"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15139275ce3397946d83bdb89d7d3fe9bac87be4de24c7d25a6e34951437aae2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19b9c266559659981d022a7d26352aca3134575b94f1fef1686a33da23f3cff8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5c50c074ed16cd315ab784a4d5aff3c465e16cbb4f7f24e462d01f59537f98f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccc691ba2e94ed2efdac2e52f005cdd8a2ecb5a6c880d7db73873b21f723e3d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fcf10d04e87a5dea69fe27875b4a6874fdb26daeceb98523804d577888da1fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c60774cdc04b32d7e29b9dc243c51caa92083356c1d9885eacae454ca6679187"
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
