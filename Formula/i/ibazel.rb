class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.25.3.tar.gz"
  sha256 "064e313f2e2fa39ebd71a8f6b5eb44e7c832b713c0fc4077811d88830aa2e68e"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c12651e6c9cbc680f6e787336fc2f2af53ccdd09cc7fafc8ee27a9317f507df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c12651e6c9cbc680f6e787336fc2f2af53ccdd09cc7fafc8ee27a9317f507df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3244d3623fc940b32da49370e3b4d78edae09fa66fc336a80dc5a2a6bfca08d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2a7ca0a10912f7e99064fa84f76e4c05a0d1e1aefc026572187c66064872f37"
    sha256 cellar: :any_skip_relocation, ventura:       "74d628872158223d2254232f97bc08654db611958b4269ed5b60aa91d8c3ec50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dd9fbcb138b56677b3123f7194cb5d13675a5cdd6f8dcfd9a41f218b3b67828"
  end

  depends_on "bazelisk" => [:build, :test]
  depends_on "go" => [:build, :test]

  # bazel 6.x support issue, https://github.com/bazelbuild/bazel-watcher/issues/616
  # patch to use bazel 6.4.0, upstream PR, https://github.com/bazelbuild/bazel-watcher/pull/575
  patch :DATA

  def install
    system "bazel", "build", "--config=release", "--workspace_status_command", "echo STABLE_GIT_VERSION #{version}", "//cmd/ibazel:ibazel"
    bin.install "bazel-bin/cmd/ibazel/ibazel_/ibazel"
  end

  test do
    # Write MODULE.bazel with Bazel module dependencies
    (testpath/"MODULE.bazel").write <<~BAZEL
      bazel_dep(name = "rules_go", version = "0.50.1")
      bazel_dep(name = "gazelle", version = "0.40.0")

      # Register the Go SDK extension properly
      go_sdk = use_extension("@rules_go//go:extensions.bzl", "go_sdk")

      # Register the Go SDK installed on the host.
      go_sdk.host()
    BAZEL

    (testpath/"BUILD.bazel").write <<~BAZEL
      load("@rules_go//go:def.bzl", "go_binary")

      go_binary(
          name = "bazel-test",
          srcs = ["test.go"],
      )
    BAZEL

    (testpath/"test.go").write <<~GO
      package main
      import "fmt"
      func main() {
        fmt.Println("Hi!")
      }
    GO

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
