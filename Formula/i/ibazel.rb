class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "b2f63188f4c25d9108903f89e3f3c1ee09016816e2ee54590dd7c6c5da43350d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff220f5873d6ea83d61eb68231ec68450e5fd6eba58d7ed5559a9a44f8389141"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ace57e4ea621a9785de4c99b3ce6ebc19f8de8254145dbf440d333315345b49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99185086ee14a9727fa710e0a11f6129c4fb8601b132bd37e6920fb6c8318699"
    sha256 cellar: :any_skip_relocation, sonoma:         "c955602d4b4d016db7078292aff68b171c28ec4b98ad97afa39af87cfa061114"
    sha256 cellar: :any_skip_relocation, ventura:        "6cbc66724381a8e9865879b33da3029a5b7e62ba45b27ff2b57a5223a1d5845f"
    sha256 cellar: :any_skip_relocation, monterey:       "6c26e5c4886d1b220d600af899e96cee5578439ee8f985832d2ece8e47ec4cf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4d41d7e120c27e03e29d0c763060a792284bc386e18e2cce315af0f515d00ea"
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
