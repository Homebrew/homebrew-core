class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "03748bca4bfee26c79743c8a1ff90df7daf871a8abf1912e093ec64adf40fcb9"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c9f8dddc7e84e19541c833919d1c40161dde460b9e98f6a8ddcf091544c4193"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c6adbb7da6f00ad440dc1b98d9b7fd52434b42aacad57c2112ca38906c766f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "175b652785bbec20c9527beb35252cce488db8f998d8dc62caeeb5d69b583377"
    sha256 cellar: :any_skip_relocation, sonoma:        "936a1b55f81e0919ff5a6b3618495986846e9cd4d43e8ef2ec30863d2b2ab9ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e776e87e3062ef8d01d963d789953bb08b2428ef7c1e5efda371643224de43d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c60074d192920ea050d7a45fd80f4e7ec0b26bd465b264161bacb686663f4994"
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
