class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "18f5773135c2cc92c4acae562178f54c4d9972425f5186e5d9f3a6a952027080"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4075760d89bb69bcddba942a2e386efdc2c8109d0e3ea81197e3c50b44436d49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f0eedc9b9e7c686be17d89a760e3c4aa5cbef0630383984f8f6ae61fc9b71a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44a777b0e98211fe37f7fe3a13202327505660b67261a78b873fb4adf6f4d378"
    sha256 cellar: :any_skip_relocation, sonoma:        "231889cea7114b6866b572484a5cd8b2665b2ec3d5287524d3055d526266918d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e24d7df45c6ecc8b49704f48409175e025da3b42cdd8c05c2df30fc4fb4ec06f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90810ad4c98551e2b0573db2d07416e57a1dc56836348f3fc54923a47abaa50f"
  end

  depends_on "go" => [:build, :test]
  depends_on "bazel@9" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/ibazel"
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
