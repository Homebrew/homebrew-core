class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      :tag      => "v1.1.0",
      :revision => "fd66bc39dffe62c73db5edabd6d872d54ae88bd3"
  head "https://github.com/bazelbuild/bazelisk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6e209c53c904eb4ea0eefb3935e24ad1330dda2c5b2a9ea822e6c0f93ed39cd" => :catalina
    sha256 "b6e209c53c904eb4ea0eefb3935e24ad1330dda2c5b2a9ea822e6c0f93ed39cd" => :mojave
    sha256 "b6e209c53c904eb4ea0eefb3935e24ad1330dda2c5b2a9ea822e6c0f93ed39cd" => :high_sierra
  end

  depends_on "bazel" => :build

  def install
    system "bazel", "build", "--stamp",
      "--workspace_status_command=#{buildpath}/stamp.sh",
      "--platforms=@io_bazel_rules_go//go/toolchain:darwin_amd64",
      "//:bazelisk"

    bin.install "bazel-bin/darwin_amd64_pure_stripped/bazelisk" => "bazelisk"
  end

  test do
    assert_match /v#{version}/, shell_output("#{bin}/bazelisk version")

    # This is an older than current version, so that we can test that bazelisk
    # will target an explicit version we specify. This version shouldn't need to
    # be bumped.
    ENV["USE_BAZEL_VERSION"] = "0.28.0"
    assert_match /Build label: 0.28.0/, shell_output("#{bin}/bazelisk version")
  end
end
