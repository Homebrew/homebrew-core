class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.21.4.tar.gz"
  sha256 "57e87637f86f7260c8619525c470e2379b6e7cf7a51bfa1b2342b1f29d306777"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70fb9e15f1baea5e6a24915c6ea10b087420022aaffa66bd1f81cff129af03d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3226ebae016c1c9583980b8101077ff55e3ed171b1e763e699fea31e41b929a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "424434a824b0748325601863238d18e925e22da91f7a26a7cc5ed6193b10a10a"
    sha256 cellar: :any_skip_relocation, ventura:        "b61e899cea4841514b85b42dac082ed5f1f8ac3d8ae49d00b9234dc1bface4e4"
    sha256 cellar: :any_skip_relocation, monterey:       "b61e899cea4841514b85b42dac082ed5f1f8ac3d8ae49d00b9234dc1bface4e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "49233ff62932a2dfe41ded272391e63a190ae801b857f583388f66d642e05fa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94a4c042fce4afc577475ad5a9492ab4e0551b1c22be275c4aaffefe766e58ee"
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
+6.0.0
