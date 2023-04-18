class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "31a6606bbceda98bddebe5d0316fa0590f588ba7fa04318eb9d485228b2adb44"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dc821017c5c7458f085a94c10d59da64ebcdb725b5763059e16e72dbef55582"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fc1981d97c3e33b8b32c967851c8dcffb86d4aeca12a06d4fa885427d0c0167"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebec32760b46e451cf71732cdf713f1cf1c1a00679daa88b7b69ad284d9ffece"
    sha256 cellar: :any_skip_relocation, ventura:        "ea05e8027f93ddc73ada9fe135a173e0cb28290e0895725f2969f45b097a689c"
    sha256 cellar: :any_skip_relocation, monterey:       "ea05e8027f93ddc73ada9fe135a173e0cb28290e0895725f2969f45b097a689c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4c3d6ccb4f22caa33cb9ba0703a53e2bf48e232ced82220cf6a54ef025d8cee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c348a5198496ef373e816c643a8dfa384638a7661184d3317dde7952399496d5"
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
