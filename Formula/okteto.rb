class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.15.4.tar.gz"
  sha256 "b5e07e462288715de4648ff59485167caf2316da6993d7c4634dc06c45cb667d"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5c5898b08e232f0aa4b404030c894f98a36c01216fcef62fd06eae1d101aff6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e64a2380952432b6d7be65be1fddf16e5fa16dde344bbfb3d03baa77898784d6"
    sha256 cellar: :any_skip_relocation, monterey:       "98c0109fe478d5c94f417e968f88f324331f9a3625e54236c342f7a65c4b82c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "6324bb733769d7562b29d58a457ac54793d030b7a9d56eaac88f8ec7504790c4"
    sha256 cellar: :any_skip_relocation, catalina:       "a3be8919295f727acd6b302925555a849994c2cfa1c9f021a8eeec0a16aeef73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76443155eef31137ff35432868851908caf03c26bcf2a38ab042f77a30ec98ca"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
