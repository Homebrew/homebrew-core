class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "910a62093c51b908a89648b0f3c1a4ff15928c1f6fe9116ec73b00036845a4c6"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b4baa756ba6cebc772d4fa0dd51170a89e535bae1a39e79b8d6b60e4d274d7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a6c43d962cc24d4f5269e7034e0adffbb0405c5264eacdc1df07ac8f1ae5f89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c7993151ab5e001dacafc89b5501739de9a93b419c3389638ffc5fde110f454"
    sha256 cellar: :any_skip_relocation, sonoma:        "f47c8051c691e08a5b95b7ccf1cd89d0deaec8d61f93dec122cf785b6b448087"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "566c2afdfe1b731ce242cadd395846fbe582329403fc7a4e62c423ff54bc60ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83ce7ea23ede410aee5efdecdf42025fb86086d939fc77e5438b559bfd32c7cc"
  end

  depends_on "go" => [:build, :test]
  depends_on "bazel" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/ibazel"
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/ibazel --help 2>&1")

    # Write MODULE.bazel with Bazel module dependencies
    (testpath/"MODULE.bazel").write <<~STARLARK
      bazel_dep(name = "rules_cc", version = "0.2.16")
      bazel_dep(name = "rules_go", version = "0.59.0")

      # Register brewed go
      go_sdk = use_extension("@rules_go//go:extensions.bzl", "go_sdk")
      go_sdk.host()
    STARLARK

    (testpath/"BUILD.bazel").write <<~STARLARK
      load("@rules_go//go:def.bzl", "go_binary")

      go_binary(
          name = "bazel-test",
          srcs = ["test.go"],
      )
    STARLARK

    (testpath/"test.go").write <<~GO
      package main
      import "fmt"
      func main() {
        fmt.Println("Hi!")
      }
    GO

    pid = spawn bin/"ibazel", "build", "//:bazel-test", "--repo_contents_cache="
    out_file = "bazel-bin/bazel-test_/bazel-test"
    sleep 1 until File.exist?(out_file)
    assert_equal "Hi!\n", shell_output(out_file)
  ensure
    Process.kill("TERM", pid) unless pid.nil?
  end
end
