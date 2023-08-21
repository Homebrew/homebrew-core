class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.23.7.tar.gz"
  sha256 "21920e77f0dca97a4b098588b60d5afefab6efc6db384c755e01084ecaf0620f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf92e59b275b9b679f1981c95662ec3a9e66f24138d8ae996977562eaa00b627"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e21a82d5ac71ad718f70508a7bd5b84e98860932dfe72330fce68bb6af5f6e76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb1c42c2b1431706f654f888d728878e8cf179d82bb67f76b396fc5824cfe4b7"
    sha256 cellar: :any_skip_relocation, ventura:        "25f3e191c945b09cc8ade60a849f54d9a72b6578643d3bd25a99124a65454a0b"
    sha256 cellar: :any_skip_relocation, monterey:       "0425b8634086d48374555a66352a4a34c22c923de1d1bb0dd47b0f9e8b091bce"
    sha256 cellar: :any_skip_relocation, big_sur:        "02e214ea899f496aabbeb88cf8d0fc656b3b4f3bf0b809dd7c09140a2cce4828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cd9fc0b538066a09667ab2888b2817c79eae97984b1e14c922aef3ebcd9c7a8"
  end

  depends_on "go" => [:build, :test]

  on_macos do
    depends_on "bazel" => [:build, :test]
  end

  on_linux do
    depends_on "bazelisk" => [:build, :test]
  end

  # bazel 6.x support issue, https://github.com/bazelbuild/bazel-watcher/issues/616
  # patch to use bazel 6.3.2, upstream PR, https://github.com/bazelbuild/bazel-watcher/pull/575
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
+6.3.2
