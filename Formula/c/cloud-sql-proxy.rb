class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "e7e7574409bc466d816c20e9cbcc476ed9d78ba923fb54be5e91cc5fccb12a55"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa723c86103e91c1a729b4f5be454056604dbe7855e3e773d6d5c16fb9727b3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2a8ca1c88e99fd0deefeb4caf5c0a8c2e696196b28ded064ca3b2f1758896b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb8c6b33f034fff78fca664d99794f0fe94290ccd2bbfb62e97db0229adf26ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ac6e3aaaeff2046394659357e90d6620ede1230f7aa302681e20f42dafb058a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c1b697bc1f09e3bf22649734fa986da79dd76a61568bac1d3e261130eab9d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "732d6dc20b24e6bb466e8cd2f88d1f7dcf226f488c0c583f24c017e05d01034a"
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
