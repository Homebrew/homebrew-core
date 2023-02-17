class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.21.4.tar.gz"
  sha256 "57e87637f86f7260c8619525c470e2379b6e7cf7a51bfa1b2342b1f29d306777"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4958702c2a95b1452c2a4860b02e31c0338f591a29db4a7d4d068100a9bde10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a124ddad5cdacf9d2cbcc83670d061f2bc585ed9d12c3e90d0e675f192fc092"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d328c6f8cbbfe0ae3f4763d48fcd2ecce110ebbcace4b7aee81c2f682537c782"
    sha256 cellar: :any_skip_relocation, ventura:        "e339b6a2196906437e1405162bf1b92981e927459b9d1ca27a79ab18fe74ce21"
    sha256 cellar: :any_skip_relocation, monterey:       "e339b6a2196906437e1405162bf1b92981e927459b9d1ca27a79ab18fe74ce21"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cfd4e769a2bcd1ffdc59af42de9af38943b295f0b4465e843aa07a67a429817"
  end

  depends_on "go" => [:build, :test]

  on_macos do
    depends_on "bazel" => [:build, :test]
  end

  on_linux do
    depends_on "bazelisk" => [:build, :test]
  end

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
