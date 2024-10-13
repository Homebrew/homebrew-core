class EnpassCli < Formula
  desc "Enpass command-line client"
  homepage "https://github.com/hazcod/enpass-cli"
  url "https://github.com/hazcod/enpass-cli/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "adc41a0ea630e4c13b7e1333f3e4fdac438a86560d06c2861f5ba9f7979e8a54"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6e6da1fb226a63e84791e495b0db8921bd6dcc975bc34c6704153fd9769610a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50d816314d8d2c7ffd19e34af768d1d26b2b25f77c47d03701f1458a66c9c219"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f020f03b420e9863eea1b148f0f283b7c2b94d5abfa75dbebf4b6796ce2ca732"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b45086b51461ca2843f3fc86f7a3b2ba774ecbbbca3ea7af02433930752d598"
    sha256 cellar: :any_skip_relocation, sonoma:         "89d29dd4c46ed305ecb14a11e7584efa0f60d9a78a7d631d180d79e70056d00f"
    sha256 cellar: :any_skip_relocation, ventura:        "ec06930c8a76bfcc382ffe6872134bdc6ae7954135fa6ce839d5d4ef2c29dbd8"
    sha256 cellar: :any_skip_relocation, monterey:       "27a6addea1a89fc6cfc20d05d0dd5a88e64e83a4eae73a2b772e47b8687aa995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b91a9dbca42279f92ee3180d2431b65dfc622585c4091a943f3088015b55b88"
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
