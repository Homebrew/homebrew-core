class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://github.com/minio/warp/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "48b47eecdc9c49357065740c62411aac5c87b36cf06f0f9d5cce93e8c6c5ece6"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/warp.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e05bb44711400871f75125f3522a29531f887b989124090bb5a1cb54a95a19d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b113fed2d68680b2b5a4ef44239c5892e1cc094bfc68612219e83572ddd398d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f8ba292adced14d74d07040c6d9371f257e32affcb9ca6c466a5caa8b2b58de"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6360cf3dd727c777a84858faa86130e8c4cd73f89f6a1bb248133d99e5f40bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4909a5f0223942bacae3a22afd8e7d66858f23f7a0dcedc16fba6d8bb3a3dd60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b052276431943851117dda12c7fc842328ed4a2fed059786b2a4ff00e08ea3ef"
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
