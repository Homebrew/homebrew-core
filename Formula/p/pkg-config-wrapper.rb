class PkgConfigWrapper < Formula
  desc "Easier way to include C code in your Go program"
  homepage "https://github.com/influxdata/pkg-config"
  url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "11776c4f44b4d338619723cba1a6ef716573e80a358b0943ff2e2a86129ca8d5"
  license "MIT"
  compatibility_version 1
  head "https://github.com/influxdata/pkg-config.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9da0d9fb97c7e177a27f6dd18bb3c14b4d0363aa92e6632922a69ee57ad2b870"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9da0d9fb97c7e177a27f6dd18bb3c14b4d0363aa92e6632922a69ee57ad2b870"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9da0d9fb97c7e177a27f6dd18bb3c14b4d0363aa92e6632922a69ee57ad2b870"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b7802619668b45918472ed24c4a957f96219cff9ebd3ab90bc19c176d877fa65"
    sha256 cellar: :any,                 x86_64_linux:      "2cfea79865ce32b2a09c9ca798e609769507991a4fdb3aecf62cc1402e99e8b8"
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
