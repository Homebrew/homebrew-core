class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://github.com/minio/warp/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "8e10189adf0d6984d638a9229ba1cb3aee26f76db02ff476e0ee60604c8159af"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/warp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd2053fe0224ec3ba2544f631756abf3b51cc793dc35bc956c3cb5e2ca5f9860"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3c820dcc736b88ebd17347eb2393af80ff197f9fa403a4de297d25b60294753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "356785da8dba392263a2a83bab320fd2a8e0d97d30ea60895adfdafb647e0994"
    sha256 cellar: :any_skip_relocation, sonoma:        "459c539513ea80d970b710ea13a9a9874fdde2b49748b453d48d2e979b21306a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c6b83176740286daf8482caddce4475a505aab38b70e5aa7a0b4e27752b422f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60bdd722bfd7f92382a9fb25e15e7cc3520cbdbacba38ba77c2a6b02be133d29"
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
