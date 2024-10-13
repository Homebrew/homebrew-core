class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/releases/download/lxd-6.1/lxd-6.1.tar.gz"
  sha256 "ef073f19b5e666f306232d7c086ec1f39bbc14672237f2fd7b65d259caead1b9"
  license "AGPL-3.0-only"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4819357eca98fa9b3275b36c9aa346a9933c7cd3562fc84cc3551d9ce05836c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a80b2547e2b6db519b582309a06f4f7905820aa626555cf4ec259ee6db58c92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0a71f095561e5c2ed19054c16455079bae4d6fdbe367f45364fcc2535c395a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fd47741213d1e89b424321a723f6c5a3157cebd794d8a49899f7002e7b49f59"
    sha256 cellar: :any_skip_relocation, sonoma:         "e21a2bfe721dc23fce826f3f9dcf63060d24eadee5b2322bd23ba72d09755df3"
    sha256 cellar: :any_skip_relocation, ventura:        "5c8951a235c73e4ed0205ea9ec398b23a048bb0470b76c25892774e1e94085a6"
    sha256 cellar: :any_skip_relocation, monterey:       "c91c3b6382c0f3c1d07cc2cf96609baffce5667bc5fbd4c7fc07f218d89d9336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a78e129573f90fa081adf1a31f7824ea4690dc93e88c21b3da97ca08aeab163"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./lxc"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://cloud-images.ubuntu.com/releases", output["ubuntu"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end
