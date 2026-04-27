class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/releases/download/lxd-6.8/lxd-6.8.tar.gz"
  sha256 "4ccfd62b4364bab41f537d5602f2c16f86dbe57f218ac225afaeba86b5decb3b"
  license "AGPL-3.0-only"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b09e56a4a38c35a1f0295016048c8fce5b66df9b364c1fae5318b299d308c839"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b09e56a4a38c35a1f0295016048c8fce5b66df9b364c1fae5318b299d308c839"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b09e56a4a38c35a1f0295016048c8fce5b66df9b364c1fae5318b299d308c839"
    sha256 cellar: :any_skip_relocation, sonoma:        "f777dcfbe9f18e1746a3a9bde14dddc911f48703a9944745e2cce1b0649e5b93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2720351ec9be3906524c409e64df9968f7a83e8330c453556294ae4077136d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fd80b4478730c1ab76f287a5b1ceb298c86927ee3b841197bd1b8d834bf6810"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./lxc"

    generate_completions_from_executable(bin/"lxc", shell_parameter_format: :cobra)
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://cloud-images.ubuntu.com/releases/", output["ubuntu"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end
