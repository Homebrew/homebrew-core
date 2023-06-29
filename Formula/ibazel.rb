class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "e7f68d8b37955931ae73611225f05c9f1b678871891c486c450846276550966b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32b111de0c15c631c97b59ce382c8246df1d53afb3c6aa14e7fe479e488459de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71affaa16f8f20ab5da12a524c68369bf250a4421de313b1e2cd491ec9eff216"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "305bca999f202b33fc8033b16273df1a7683ee1562ce49601afe2ffa928f3bbb"
    sha256 cellar: :any_skip_relocation, ventura:        "a6dd613c412a5ba9095227c5d6c2e72706e2a232fbd77884434f24150dbd5056"
    sha256 cellar: :any_skip_relocation, monterey:       "4007bf96a5a56368d55124ee83334bc429daafb2fa1eb90b7877d5189c7d6485"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0e6e437cd32b794c9305da97c66695f59e5e2aa2b0863d5d197c8ee8c98a63a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bd8e04a49db4b359eefec5122e2370316c4e505bcbf71968f94d13b7647ae6b"
  end

  depends_on "go" => [:build, :test]

  on_macos do
    depends_on "bazel" => [:build, :test]
  end

  on_linux do
    depends_on "bazelisk" => [:build, :test]
  end

  # bazel 6.x support issue, https://github.com/bazelbuild/bazel-watcher/issues/616
  # patch to use bazel 6.2.1, upstream PR, https://github.com/bazelbuild/bazel-watcher/pull/575
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
        sha256 = "dd926a88a564a9246713a9c00b35315f54cbd46b31a26d5d8fb264c07045f05d",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.38.1/rules_go-v0.38.1.zip",
            "https://github.com/bazelbuild/rules_go/releases/download/v0.38.1/rules_go-v0.38.1.zip",
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
+6.2.1
