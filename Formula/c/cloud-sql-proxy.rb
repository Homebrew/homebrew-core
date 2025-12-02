class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "6bea89b43b858590a4f6f7cc48a8490eb8415f22caca408c4ed8eabd47241bcc"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85c59b49db506c90b7e0fd7021e2fc23fab86f059c5495c8d4ddeba3445a216c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d226886f846c2820a04a0847ffaff462bb0a69b36003441c0345662e85ab2965"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97de612d87d437ef257efa9f3e6a4ac1303e483312e577742be73cc94c6e18e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc89b81086c31a78ac326ab5c9b652e647db6e473b302cba779ed19d7c3db7f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "262f4f71466a8f0a9d48d001213b61a224127019b67f82c48b3c8fcc7b2021b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1b5459568292af592670a9c9dd7bdbda210c844ddc94416541f58e49dc95e68"
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
