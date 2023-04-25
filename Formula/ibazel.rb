class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "73982531bcaf5303e8fc2ed989a6a1e7eea6974d42c2cd10978a889674b186fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3ebbb32bf351f646abe0cd5f45600754057dee30e689815e48aee40c16d6790"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51af926fce60576a1674bf02fc33111b24348b1579c5e8f7d3e38b4c9ee79d4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e154faec1f6d48c7418dcfd0c5ec7b106aa8c204a1ff04fa1548ccdb729e06fe"
    sha256 cellar: :any_skip_relocation, ventura:        "2c801d422afbd6f648a6a94d44a6f384346025138a3e0b564ba913050e75e8cb"
    sha256 cellar: :any_skip_relocation, monterey:       "9778ec5dbe0aba34a7c5c818703125d9d6462f47969e1a6542af77beb1e14eb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc14c9601af458505597acc76847fa1d0f5bb59a212ce8616607304a61d8ebf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "facaf7e20c4ed1f4d665f98f8e07e1df783b7d66097e2dacaaba359e6bad96a2"
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
