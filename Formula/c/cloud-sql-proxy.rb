class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.24.0.tar.gz"
  sha256 "302d36cc853fb98c89e37b7646b99525d1660bc9129231e3a0daf8695f3162f2"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcfd9dc483ce02d193da9b797f7db2187ff244a20589f9ea793c92044d513dac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ec62761c4a8ceb8ecc574c6aedd220a21981c88aa8ee6d4e4e8cf4c03224bfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8c27ed244f188734c34e16c7a96cb6c58d3f92cabd2063f69113e2a6cf3484c"
    sha256 cellar: :any_skip_relocation, sonoma:        "17b93498a498e7d4c168e3920c35be0fa7bf55f26a9b2e7dca3db916aa850cd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa5fb5d3b3a53526ae7329a10bf0e49fd8e3288185d98ba4cc500e644b8bb7f6"
    sha256 cellar: :any,                 x86_64_linux:  "1e12305f1cf2f5776bcee80e7ca1035f970ba7ce7d1d029d180dbc84dd4627c3"
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
