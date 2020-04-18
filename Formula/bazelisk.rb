class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      :tag      => "v1.4.0",
      :revision => "1e4c5df59ebf03feb6ec01fc489751f1db62b89e"
  head "https://github.com/bazelbuild/bazelisk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9a394c4e1f686f37b62040be9e8fcc7571bfd32d8c9ff9a43e6c59905053a4c" => :catalina
    sha256 "e9a394c4e1f686f37b62040be9e8fcc7571bfd32d8c9ff9a43e6c59905053a4c" => :mojave
    sha256 "e9a394c4e1f686f37b62040be9e8fcc7571bfd32d8c9ff9a43e6c59905053a4c" => :high_sierra
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
