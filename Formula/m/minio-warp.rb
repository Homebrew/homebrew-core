class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/warp.git", branch: "master"

  stable do
    url "https://github.com/minio/warp/archive/refs/tags/v1.1.4.tar.gz"
    sha256 "1a8055bd4a8fc2e9bee6b93ebf3f0fa5dbbc560c8f9f53832ee885c88566fef5"

    # go.sum update
    patch do
      url "https://github.com/minio/warp/commit/c830e94367efce6e6d70c337d490a3b6eba5e558.patch?full_index=1"
      sha256 "69d59f334cb60fd0d8aaf6426c27a1a995cad494e49024187673baba3bf35ec6"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f96a3959319137654f59cf95f39b802f4294e903b496f1bb818f55a248fedaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad0cc0c54056c3e1a65140276c1a4859222e6866a75343bbf062a0575c50332c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34275103e3292958edc850991c4b0fa4cb575366cc4f6077b0fc20676f8224c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8812e75d4f70ae276dcafb3c5e5ce2cfc458b9ad8be9948bad9225ae6abe3231"
    sha256 cellar: :any_skip_relocation, ventura:       "e51bcfc2fde33bd43e3e9293eb22cec1a3176a3e797487bb1bb654b61210225e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd0deb74bdb394b6f27aa152a0da6eac1ebccaf345233fc5dcf2423910301b82"
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
