class PkgConfigWrapper < Formula
  desc "Easier way to include C code in your Go program"
  homepage "https://github.com/influxdata/pkg-config"
  url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "c23dc2db950ed7938d6f528ca265a9c09ebbdad74e59b90cb66ecb93fc299ab2"
  license "MIT"
  compatibility_version 1
  head "https://github.com/influxdata/pkg-config.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "e005506bbba7c58d570c121fbf9f4bb1d6436a89f961531c592fd99e7ace824f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eaa5fece3f6bf6d26e25c19178cb1db07edc5100e00455fb3b591cc1084f59ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eaa5fece3f6bf6d26e25c19178cb1db07edc5100e00455fb3b591cc1084f59ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eaa5fece3f6bf6d26e25c19178cb1db07edc5100e00455fb3b591cc1084f59ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "34de32c08738176d1ec712dd8a898f747795b3337cc88f8307417e030f38d2b9"
    sha256 cellar: :any,                 x86_64_linux:      "43eded48fd8a82fc90dec35152403ddf5dbda86ebc61f94f7e7f3dbdf8477faa"
  end

  depends_on "go" => :build
  depends_on "pkgconf"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "Found pkg-config executable", shell_output("#{bin}/pkg-config-wrapper 2>&1", 1)
  end
end
