class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.18.tar.gz"
  sha256 "fe4ed6149c992557c2934532efc1aa80781048c733f33ffe0d1a627ed9973116"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    manifest_sha256 "869ec31c6bbd953876a02e0475bd20387b49abc5a55f8e75f3e981a76c6b4eef"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c0ebc11bfa49ef7b2fc0af5cd99c715fd3f8080ae699eea8229c25a01c68d1b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c0ebc11bfa49ef7b2fc0af5cd99c715fd3f8080ae699eea8229c25a01c68d1b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c0ebc11bfa49ef7b2fc0af5cd99c715fd3f8080ae699eea8229c25a01c68d1b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3457e0055a73a62eb5f42d5096aec10110b0132fcff7e42f127291dd10267365"
    sha256 cellar: :any,                 x86_64_linux:      "65493e90759baf7fcf8a2976c079b0a5c955604bf17cdf4ab65a5d1aa191ef25"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
