class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://github.com/minio/warp/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "c2b9e76f76a97c87298b188407b5b50a9e8161262c25c42342289dd7bd9ba651"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a78e78961699d3deabd9897e87d895a40c7b6746bdb2a96d249f55ae5ffc642d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bda588f8986cecf234a1d42dc407dd77aa481ca6ecc3c86987849d823b4f7b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd6321646c7104ef3d032c1a9c321ab495bb905a2931b9aeda0be0974966dc2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3d68da1f4f219f9c7070eef5bffa77a5d15180afa380cffbd8692022460adba"
    sha256 cellar: :any_skip_relocation, ventura:       "bce8f5e38fd661ab5b5ceba33ff2c3e6486854f04025a0797555d3d806661138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "661c42df7703455156f3e88c70b9b34edae977f57cc3e24fdd32c78bace14cfb"
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
