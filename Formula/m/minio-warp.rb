class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://github.com/minio/warp/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "311a115585adab9ed99626320d6e03670c73823f2801f54296ab4f9329a64032"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/warp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "638375991fe8f04f67d340ddf2c9a3558bca78c3b8f89e3a1c234fdc7a25ebf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beb84bee044d536201212787d516a4ee4d32e55a40834bdf7cd191c826bedf2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2479be38ba93b124fd41cf124fba835584183f048d3c0560f564d7e1af13f315"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fa962c70ea6a83943d0865880fc66d33a0e9fadd582cf5bc34d6c105fab6370"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e69dea59218a82b6a7db13b5c90e71fd7cff54b19035293d36401f3933e574ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "607d3c87049c155f6c18ee1ab45496f193a44877f95a1ca95014b0a39cacfb9e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/minio/warp/pkg.ReleaseTag=v#{version}
      -X github.com/minio/warp/pkg.CommitID=#{tap.user}
      -X github.com/minio/warp/pkg.Version=#{version}
      -X github.com/minio/warp/pkg.ReleaseTime=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"warp")
  end

  test do
    output = shell_output("#{bin}/warp list --no-color 2>&1", 1)
    assert_match "warp: <ERROR> Error preparing server", output

    assert_match version.to_s, shell_output("#{bin}/warp --version")
  end
end
