class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      tag:      "v0.13.0",
      revision: "c9d51bbe0133968858aa9991b7f69ec269126599"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/go-ipfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb349ff0435eaadd3f4e8c1c0839500e365b8c905e2f548b05ad2866d0181107"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "049d30ffda8146ff4f3bdbe222e11053465267f30cf766d1804b6aa79fabab40"
    sha256 cellar: :any_skip_relocation, monterey:       "04432091e72611f00b4c7608c793d722401c743e4e32ef05b998908e0ab185ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f860b4632e87e8f763e53b7077d1f245d2467b6cd4556bcfcd8e68149ff7efc"
    sha256 cellar: :any_skip_relocation, catalina:       "603de813a4eecd91d616966f5fab469fc3125344d1d87078ee5774a322750069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f2a47d461bef41ce50bf271a5ffae00d7cf809f9a4425b308828a491cfdb72c"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "cmd/ipfs/ipfs"

    bash_output = Utils.safe_popen_read(bin/"ipfs", "commands", "completion", "bash")
    (bash_completion/"ipfs-completion.bash").write bash_output
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output(bin/"ipfs init")
  end
end
