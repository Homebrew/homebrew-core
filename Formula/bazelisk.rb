class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      :tag      => "v1.5.0",
      :revision => "9f7127db3c137e32a21484f9345bbc0da8301135"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c189bca9ddac7acaab8da42f451a8707320c52b4b233ab9b42cbfefc94310d9" => :catalina
    sha256 "9c189bca9ddac7acaab8da42f451a8707320c52b4b233ab9b42cbfefc94310d9" => :mojave
    sha256 "9c189bca9ddac7acaab8da42f451a8707320c52b4b233ab9b42cbfefc94310d9" => :high_sierra
  end

  depends_on "bazel" => :build

  def install
    rm_f ".bazelversion" # Homebrew uses the latest bazel
    system "bazel", "build", "--config=release", "//:bazelisk-darwin"

    bin.install "bazel-bin/bazelisk-darwin_amd64" => "bazelisk"
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
