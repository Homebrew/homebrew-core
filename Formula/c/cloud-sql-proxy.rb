class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "5c79233727c459cf6123130139d6343cd46111ce141ebb50c07a8b546c40a514"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "555a5802d641ae48384e2e0dfe5fc7b0b020b77b3af30fddd4c26a74b286946d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "555a5802d641ae48384e2e0dfe5fc7b0b020b77b3af30fddd4c26a74b286946d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "555a5802d641ae48384e2e0dfe5fc7b0b020b77b3af30fddd4c26a74b286946d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e41c2837f7c28c486074819ac49a3cb995752d7771129adf1ac6503429891cf"
    sha256 cellar: :any_skip_relocation, ventura:       "3e41c2837f7c28c486074819ac49a3cb995752d7771129adf1ac6503429891cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c472988593158fba390868b930b8be8407b0c888ec14a154a4235ee57208fcd9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end
