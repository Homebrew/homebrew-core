class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      :tag      => "v0.0.8",
      :revision => "a843c2abd36c7a6167ef1e41d5145a4f04cf6900"
  head "https://github.com/bazelbuild/bazelisk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2af3f5d76ad89dd102a9fbd4a384b8ed53e846242bbae307a1fd6bd3cc583101" => :mojave
    sha256 "2af3f5d76ad89dd102a9fbd4a384b8ed53e846242bbae307a1fd6bd3cc583101" => :high_sierra
    sha256 "0b117bdc259c674f345ed4d87c3910a56f9629278d3a6efb7eb52d7f590450ac" => :sierra
  end

  depends_on "bazel" => :build

  def install
    system "bazel", "build", "--stamp",
      "--workspace_status_command=#{buildpath}/stamp.sh",
      "--platforms=@io_bazel_rules_go//go/toolchain:darwin_amd64",
      "//:bazelisk"

    bin.install "bazel-bin/darwin_amd64_stripped/bazelisk" => "bazelisk"
  end

  test do
    assert_match /v#{version}/, shell_output("#{bin}/bazelisk version")

    # This is an older than current version, so that we can test that bazelisk
    # will target an explicit version we specify. This version shouldn't need to
    # be bumped.
    ENV["USE_BAZEL_VERSION"] = "0.26.0"
    assert_match /Build label: 0.26.0/, shell_output("#{bin}/bazelisk version")
  end
end
