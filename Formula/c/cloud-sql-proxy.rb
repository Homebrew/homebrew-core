class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.21.1.tar.gz"
  sha256 "e5b710d80b176bee58be78d122f61bc1c504826f74932c1cd6e792652aa38d54"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c8b63a8a61963c1541ed5fc5b0a303e1efa5a8ac5fa4c2f6ff9a03c2c536733"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c8b63a8a61963c1541ed5fc5b0a303e1efa5a8ac5fa4c2f6ff9a03c2c536733"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c8b63a8a61963c1541ed5fc5b0a303e1efa5a8ac5fa4c2f6ff9a03c2c536733"
    sha256 cellar: :any_skip_relocation, sonoma:        "68ba83dd7f95ae76f0f6752d6e109b95cab0b8098c5ee090c0246fe0f670ecb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddf2095a959096686b626c7e86e9df861205ea258e0d3f73a99c6e92946f61ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab17f20903f1aeae843b0161deaae45d54cb45284b8d9e59fbca3e443735f83a"
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
