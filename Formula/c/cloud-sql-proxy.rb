class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/v2.7.0.tar.gz"
  sha256 "75911bbfe61a46d70ae0f6e1370d765164dab23fe2138f57bab938ebaed6618f"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f121d75417577768d81d2bdee825d1cba0020126379c09ce2c394e4749c5f44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f5a8771075a8a6505679bb91d6f35f232fbe9c9761ee81b592becf4ce9a9123"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6837c15743c3407db8603ce77c5a979954faaf37467087a741919fd536ab320f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56de1227bd36f10d7ca3599d352b6dfd4e5fdcf37f83815dc7f477acd9d65b0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c939a5be472a82d0fd733837e4392090967b66f9a2c704f47b65091764a97820"
    sha256 cellar: :any_skip_relocation, ventura:        "5aef455eb91f957aeb899a40157c4fca0fb43bc59c987b9327748478b5bd900f"
    sha256 cellar: :any_skip_relocation, monterey:       "905d451fe7139f76bf757cb53a5c5b0b5f339a4dee8832930977a3fcaa0cf54a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e16a70d50fb6001da595741d3f2a4b7849f303ea49c6aa32426e06c858b7987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79300e72acc1161cbff9e167ac1285e5ac3168cfb383d20974ae1d32a634e306"
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
