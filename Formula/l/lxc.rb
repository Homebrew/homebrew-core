class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/releases/download/lxd-6.4/lxd-6.4.tar.gz"
  sha256 "69fb7aead2325c7a5eede6dcb1a943a0f6544892929e6ae394729582abdd9aa7"
  license "AGPL-3.0-only"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "680831e50844065f167f9bda1224a8779bea2e5ea5f3c36ac8950ff241cc3a56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "680831e50844065f167f9bda1224a8779bea2e5ea5f3c36ac8950ff241cc3a56"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "680831e50844065f167f9bda1224a8779bea2e5ea5f3c36ac8950ff241cc3a56"
    sha256 cellar: :any_skip_relocation, sonoma:        "0de8398833d6d560eb0d6583120e20ffac199a993631ff50298d51b328408a86"
    sha256 cellar: :any_skip_relocation, ventura:       "0de8398833d6d560eb0d6583120e20ffac199a993631ff50298d51b328408a86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be1c55d9fc6b5bf7d841240c5e2d795499297642c014b5b5389ed1d66e2ec129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f882a67a1241a812fd53d5ab2cb43135628b27fd42974e3e2f0ebd08a8fd480d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./lxc"

    generate_completions_from_executable(bin/"lxc", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://cloud-images.ubuntu.com/releases/", output["ubuntu"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end
