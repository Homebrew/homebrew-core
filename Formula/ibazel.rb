class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "b0ea333083bab36703670a11688833493ce4b42beb3590398bd6973c0d7cbd86"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dae3ba02b9728271f950c9ad2649263972ef73d17598168afef4ccdfa1d0044"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a0b6be1029e9553d345c58f7e06ed770a2bd209304ea8b2dedd0ceaf98b213e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d0705d4358c659102a4d720517914ab358cd9c05eb53e5ee59515497d2429ee"
    sha256 cellar: :any_skip_relocation, ventura:        "097f5aab0cf3ffb1d6b9ebb3c4ac551e7f744a33608105e7640b9e22cb91d1d5"
    sha256 cellar: :any_skip_relocation, monterey:       "6d1ca535a5ed46f555b088448f31f11234dd58c72d8b0fbac65db8bb283a42f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fa3ff697ebb258dc1d32995487f56670481b46bd5e03b2687925f00ca103421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a846a4e8b59adbfe971975156107c362f67eea31ec0c9ffeaf388064ab492efc"
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
+6.1.1
