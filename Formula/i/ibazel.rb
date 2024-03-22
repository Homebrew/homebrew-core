class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "bc0ac30e84aa8b8a18ae1fc69d9ef6c575a9fa28239f36b6d14d3603e2b1d667"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "327eb4aa65bc834e884f76b5af270bfc5145ea1f4388c54fe7535ae1255b642c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "399db101ac48b5a109cf803e4fe27f433213b49c459abe4e26a080700904ee60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53489f1fdcd03db40ca83cbde1cb7b3d77d3402a1768c249f2c848af4e938470"
    sha256 cellar: :any_skip_relocation, sonoma:         "4639defe58380b5824d980f2738ab145e7dadb996de0276259fae5c3dceddf49"
    sha256 cellar: :any_skip_relocation, ventura:        "adfa8dfab533aa4082cebeb011b5170c0d4a859357fde36e8dd67be019b7367d"
    sha256 cellar: :any_skip_relocation, monterey:       "804a47113c9b4c603fe6a78c8854179adcdd720f123341d396dee31fce120b1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce6f8c1bdf830475aa19d04cead3b3d13e2827c53626cf289b3a4cf8920c1162"
  end

  depends_on "go" => [:build, :test]

  on_macos do
    depends_on "bazel" => [:build, :test]
  end

  on_linux do
    depends_on "bazelisk" => [:build, :test]
  end

  # bazel 6.x support issue, https://github.com/bazelbuild/bazel-watcher/issues/616
  # patch to use bazel 6.4.0, upstream PR, https://github.com/bazelbuild/bazel-watcher/pull/575
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
        sha256 = "278b7ff5a826f3dc10f04feaf0b70d48b68748ccd512d7f98bf442077f043fe3",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.41.0/rules_go-v0.41.0.zip",
            "https://github.com/bazelbuild/rules_go/releases/download/v0.41.0/rules_go-v0.41.0.zip",
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
+6.4.0
