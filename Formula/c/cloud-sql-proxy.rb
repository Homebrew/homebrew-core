class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.25.4.tar.gz"
  sha256 "81efc0efbb2604681aafa8af7b697bdae65392eedae1936f6d1065e55dc4e543"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "89e5ae370395fce2499f2fd804db32888c8e7d9925fbc6b1c12ee5b0f6a10cac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c2d75774948a72d84836f889e1bbfdab69bf057cd2c8eb57c40fae19fdbc2d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "64e4a2f94991d62b2c2e8e133472b0e9ad0c87117eb5d467a6d73691d9696d5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "c52dc7415e7b9e290c5be2fcd13429a1698220c9f4984030c7e30dae42b1370a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1ac674c19c362238e2a1515b979940f25d319d77304a8b9cf9f34f4ca35971ff"
    sha256 cellar: :any,                 x86_64_linux:      "dcaf7ee02b4d878b36e16a75fbb6d195c81134a26c31c7e5e53badbb2d520254"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"cloud-sql-proxy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end
