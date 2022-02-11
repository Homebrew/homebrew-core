class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "http://d.dtm.pub"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "1ce7260377d2348bca498a9980ff7884b86ea65227688fcc106e4551a31e7328"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a206b975482b18c7376807aba82f80ad0f64409ea4cf0e46468bade0b5fd349b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d96fe7286f482f0756d91735f73d2b6a8d2c64bc6fd8b88cc06024a6e55ee5a"
    sha256 cellar: :any_skip_relocation, monterey:       "dfaebbe04ce4fffbe0af06743e3f8efccf609734b739df47b6a579c369bbe50f"
    sha256 cellar: :any_skip_relocation, big_sur:        "20e1b04c8610fe2efaec8e3a38b48445d979b58387d47eca295c60aadbe0e826"
    sha256 cellar: :any_skip_relocation, catalina:       "f32bbc95e08740cea3c9f82c393483685dcd85e0255fae340c46d9d38cfe9264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efe3a7da589c3d08914a1ccfd5d2e0d62cfbf8514df5190917767f2c3b7bb7fe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dtm-qs"), "qs/main.go"
  end

  test do
    assert_match "dtm version: v#{version}", shell_output("#{bin}/dtm -v")
    dtm_pid = fork do
      exec bin/"dtm"
    end
    # sleep to let dtm get its wits about it
    sleep 5
    assert_match "succeed", shell_output("#{bin}/dtm-qs 2>&1")
  ensure
    # clean up the dtm process before we leave
    Process.kill("HUP", dtm_pid)
  end
end
