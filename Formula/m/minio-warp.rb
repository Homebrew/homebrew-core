class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://github.com/minio/warp/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "5f0f8cbffccb4685cb5d1b191337369becf8fdd65277b68b189eb1e9eba6647b"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/warp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e309a30a86d40b1e79aa07a9d15224772a688c4c3ee9d210f7552efb7211c68"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22c517bd8e66fde990c6fee120bb09225aa82277298a833a8659be21ba1dff46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "07b66f60e1f5f4118410010a5b41a6691821e72830b64f2d6718193bc2aa9e98"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a6902a23b164b4779a298d48143fd6ef2b55a2668bca9ba5fcfc33fe6d3f8b41"
    sha256 cellar: :any,                 x86_64_linux:      "1e91c9f4cb1783521ea05fea41638985ed51951650607794e3fdab4f6fff7ba6"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/minio/warp/pkg.ReleaseTag=v#{version}
      -X github.com/minio/warp/pkg.CommitID=#{tap.user}
      -X github.com/minio/warp/pkg.Version=#{version}
      -X github.com/minio/warp/pkg.ReleaseTime=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"warp")
  end

  test do
    output = shell_output("#{bin}/warp list --no-color --quiet 2>&1", 1)
    assert_match "warp: <ERROR> Error preparing server", output

    assert_match version.to_s, shell_output("#{bin}/warp --version")
  end
end
