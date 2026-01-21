class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "0980376418547e9cd611a84486fb63ea5fb1e5e9b675af4295f3c42f0c95de7b"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30fff622b432c67c8a7345aab6676f4f877b0b01ae0477a4790744e4955d66a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcd279f8a528a6319ad87823196f36d969329d4fdcd019ba6f3e5f6049b58f44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab54222d5e0fd586a5e4100e633e87bdde16fcb98e5286832440a8f59e4d832e"
    sha256 cellar: :any_skip_relocation, sonoma:        "07b3de25b4d65d21d88afd681fcae750d62805c505012f6d8a042b3db2cfbcfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e909aa73f12454b082c44d5daaa2178b54ae55657155818f8b9ec7b3042f6524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be4747421c9ea060b4ca6dc9b9f57aab75905c658c5fd227c9108c1da88f801"
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
