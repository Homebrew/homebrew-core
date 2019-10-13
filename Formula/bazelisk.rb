class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      :tag      => "v1.1.0",
      :revision => "fd66bc39dffe62c73db5edabd6d872d54ae88bd3"
  head "https://github.com/bazelbuild/bazelisk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5cb166cc44c2319bfe8207c75625f8bdbd492acde22b687b1cf48fde7a77f11" => :mojave
    sha256 "b5cb166cc44c2319bfe8207c75625f8bdbd492acde22b687b1cf48fde7a77f11" => :high_sierra
    sha256 "8d7f3f8b9fa7ffe5703a1e6c1f1fd78b898e73e4c2b13c1144e365b702d5b9bd" => :sierra
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
