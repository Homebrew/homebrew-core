class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.23.0.tar.gz"
  sha256 "36f4eab1f740498fd238c6ab6865f6a37266c1245e6d137801f762116ef33994"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b39368a81481c1560b3256cfa55880738ea698e5bf746d43c8001dd321238f2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d78b2ccc457f0ecf4e63d39ca7c46882b98fa8f0af8cde851c1933245e796b63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5e0f3e6bafe212f59ae88a3702a0892e6aeccf74dc535100b97ac99c1886c2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cdc091c5dac30b6343339ab91f98e6d3f9e8bc2c9051dd4ae75bd2f8865a83f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14c31e455a0ab7f4a54617b687fd9d0f365bbc73e9287bdb7b0657e77c98cf60"
    sha256 cellar: :any,                 x86_64_linux:  "a794e1eaca6782e1199c8fcd1f4da0fc1ef1c612cfd0bb3cfe7cee9b0059293b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloud-sql-proxy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end
