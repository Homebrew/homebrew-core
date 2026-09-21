class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.36.6.tar.gz"
  sha256 "8608be7d0e14e4d7a38b3cc958a14fca18ec6d4adc509a8562f77fc7a35e7f3e"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "41dfadc32f8c5e803bd0fa9ffba6face713c1e99f546ac3b090423f77814b5d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e326fd73d058db39d39137883290068b47b5da43f47c351c8cc6b5be8f30f92d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ca1ce99bbb2d91d3c62b869804c8007708546cf2f6e8bf24475eb7e706c0d27"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "727c520f097da9abe0f3665580feeef67355022c81b6ef4671e5bfed51e46eb4"
    sha256 cellar: :any,                 x86_64_linux:      "ff96053481da758b5db54e16ca3e2ce758642dbad07c48e894b582b14c74b86c"
  end

  # TODO: unpin go@1.26 when coder supports go 1.27
  depends_on "go@1.26" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
