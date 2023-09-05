class EnpassCli < Formula
  desc "Enpass command-line client"
  homepage "https://github.com/hazcod/enpass-cli"
  url "https://github.com/hazcod/enpass-cli/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "25668bb30747dc566695ff7f30e65fa2e29b04f5896155a4ab03185d8f5b4111"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67158376301a2f3e721a54503975bd0e7c80cd41d19cd6f6ed4e958a4d5519e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3886bf0f30fd5016e681694bf4bb97b3574faeae9bf9ac7739897a33719b2420"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8c56d9ddabab190cfaecdc750ed9012995cea8031e4a03388048b99b6e62ab1"
    sha256 cellar: :any_skip_relocation, ventura:        "595299a62c2019cc33106f208551d214e0e8021e796110bed6fb53c9c3c18136"
    sha256 cellar: :any_skip_relocation, monterey:       "4cacf3c72f633df99482e9735717dd6328526ff7b6f3f87f818bc90c7698ac8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9f4ae75f92797bb83b3e7d3ddb8d4d7716fee9ea43d688edcb7099d7d176c70"
    sha256 cellar: :any_skip_relocation, catalina:       "30e28c45feee0e71a307cd84934d093b5b6279b0a5b963d75046b7cd8914048e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11e1d47d23da2b08f44c9d991004b3d8ebee28c00bd84ed3f29d0a9a50a65857"
  end

  depends_on "go" => :build

  def install
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
