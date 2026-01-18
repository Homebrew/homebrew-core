class EnpassCli < Formula
  desc "Enpass command-line client"
  homepage "https://github.com/hazcod/enpass-cli"
  url "https://github.com/hazcod/enpass-cli/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "8dd9b954edf587f20a02204a81c4e54eb8c0049172b5e18a0a82c165b435b840"
  license "MIT"
  head "https://github.com/hazcod/enpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bab7aa08543ee47da0ec186173b71b8d02e8f1f7fc234e070b0e44fb32221b61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bc5700f879395db54953278c90b5c040e965f777fdbfd00588956db0713a651"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68ecb58bfb572f902889acf487f6880540a0c8b4d0d5664b8872bfeecd953e21"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef81033c5f7e63b40a866c5cd39d36a0cfb11f4f51eecc36bd8b42fedc79a877"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e899ad309e7542b14eaa6ed11a4dced8cb742076f5586b7c0854830f921a46a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9e8ef9174db0f1b1426b4c016a91d9d6b562d1760aa60040b4ef847755e6e1f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'main.version=#{version}'"), "./cmd/enpasscli"
    pkgshare.install "test/vault.json", "test/vault.enpassdb"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/enpass-cli version 2>&1")

    # Get test vault files
    mkdir "testvault"
    cp [pkgshare/"vault.json", pkgshare/"vault.enpassdb"], "testvault"
    # Master password for test vault
    ENV["MASTERPW"]="mymasterpassword"
    # Retrieve password for "myusername" from test vault
    assert_match "mypassword", shell_output("#{bin}/enpass-cli -vault testvault/ pass myusername")
  end
end
