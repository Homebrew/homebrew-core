class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      :tag      => "v1.2.1",
      :revision => "56a03d98104be7cfa57d4bbdc03b4c7cea29a6c9"
  head "https://github.com/bazelbuild/bazelisk.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b67457baf627d399aadd91e420886a7cfaca0d715940b168750f63164991054e" => :catalina
    sha256 "b67457baf627d399aadd91e420886a7cfaca0d715940b168750f63164991054e" => :mojave
    sha256 "b67457baf627d399aadd91e420886a7cfaca0d715940b168750f63164991054e" => :high_sierra
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
    ENV["USE_BAZEL_VERSION"] = Formula["bazel"].version
    assert_match /v#{version}/, shell_output("#{bin}/bazelisk version")

    # This is an older than current version, so that we can test that bazelisk
    # will target an explicit version we specify. This version shouldn't need to
    # be bumped.
    ENV["USE_BAZEL_VERSION"] = "0.28.0"
    assert_match /Build label: 0.28.0/, shell_output("#{bin}/bazelisk version")
  end
end
