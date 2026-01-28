class EnpassCli < Formula
  desc "Enpass command-line client"
  homepage "https://github.com/hazcod/enpass-cli"
  url "https://github.com/hazcod/enpass-cli/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "9880a54d3364aa2b6f51dffcbc54954ab5c23258d9c853cb322df0eaf1f18c09"
  license "MIT"
  head "https://github.com/hazcod/enpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f4c65deef9138ce6d66c75a647e933cbe7b628ab0eabc35c178cfd48944e345"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e08f0374913de40e976e5246c8e182e5678a6d33688f957d0acb26842539973"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca3d5627190829d134fe3508d260d3f2ee38854b2ac918434cf0ba94b8e4b88a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8be313ef773474f8c13e121e8ab01de5a9782624942fd19caea8d36abc0dbcf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6a83248b6d9d7dd31a1e98f5c350e5198fa375a1de7326d841019cf0fda00b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f1ef5d380f0184098afd4437c590a370e352e538fd22437e4b10743daf4dfea"
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
