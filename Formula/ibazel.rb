class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "3000bee81750a0e34c69ca250c0974952152232ef9f23879791eebb18f5615e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "589e6363b32a7b04d26c82ea20f0cf1c57bbbf8032a85184a51b10c099b73a8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96c2e05c6989413b925022963934672797bb1c2a6fd84c2094487b904d0178d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0ef0efb3f2ddd64c0ef4091de7fe73533e9426944b2966c3305dc961735542a"
    sha256 cellar: :any_skip_relocation, ventura:        "2eb34b4a29ec5bd9eea7dfec7edf6f6b2c93c23dc3fe4f83f67d57bbddfc1ddf"
    sha256 cellar: :any_skip_relocation, monterey:       "2eb34b4a29ec5bd9eea7dfec7edf6f6b2c93c23dc3fe4f83f67d57bbddfc1ddf"
    sha256 cellar: :any_skip_relocation, big_sur:        "baafd1ed952af966721f4982c9fc4cd746b1c3c7adfab0b0f49d94008570a1ca"
  end

  depends_on "bazel" => [:build, :test]
  depends_on "go" => [:build, :test]
  depends_on :macos

  # patch to use bazel 6.0.0, upstream PR, https://github.com/bazelbuild/bazel-watcher/pull/575
  patch :DATA

  def install
    system "bazel", "build", "--config=release", "--workspace_status_command", "echo STABLE_GIT_VERSION #{version}", "//cmd/ibazel:ibazel"
    bin.install "bazel-bin/cmd/ibazel/ibazel_/ibazel"
  end

  test do
    # Test building a sample Go program
    (testpath/"WORKSPACE").write <<~EOS
      load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

      http_archive(
        name = "io_bazel_rules_go",
        sha256 = "56d8c5a5c91e1af73eca71a6fab2ced959b67c86d12ba37feedb0a2dfea441a6",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.37.0/rules_go-v0.37.0.zip",
            "https://github.com/bazelbuild/rules_go/releases/download/v0.37.0/rules_go-v0.37.0.zip",
        ],
      )

      load("@io_bazel_rules_go//go:deps.bzl", "go_host_sdk", "go_rules_dependencies")

      go_rules_dependencies()

      go_host_sdk(name = "go_sdk")
    EOS

    (testpath/"test.go").write <<~EOS
      package main
      import "fmt"
      func main() {
        fmt.Println("Hi!")
      }
    EOS

    (testpath/"BUILD").write <<~EOS
      load("@io_bazel_rules_go//go:def.bzl", "go_binary")

      go_binary(
        name = "bazel-test",
        srcs = glob(["*.go"])
      )
    EOS

    pid = fork { exec("ibazel", "build", "//:bazel-test") }
    out_file = "bazel-bin/bazel-test_/bazel-test"
    sleep 1 until File.exist?(out_file)
    assert_equal "Hi!\n", shell_output(out_file)
  ensure
    Process.kill("TERM", pid)
    sleep 1
    Process.kill("TERM", pid)
  end
end

__END__
diff --git a/.bazelversion b/.bazelversion
index 8a30e8f..09b254e 100644
--- a/.bazelversion
+++ b/.bazelversion
@@ -1 +1 @@
-5.4.0
+6.0.0
