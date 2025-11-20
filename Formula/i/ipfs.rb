class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://docs.ipfs.tech/how-to/command-line-quick-start/"
  url "https://github.com/ipfs/kubo/archive/refs/tags/v0.38.2.tar.gz"
  sha256 "2b0fa6b796aa86726a695e872d4854dd909a65234ea598e3c4a155cad3591fc6"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/kubo.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdbf1c7546764548473ba4d44051f9f4ca76262866bd5a66811309a9babeeae8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d547e1b4c5e681eacc98a4623d87b751689cdc90f6e083030d0f7f0fbf750a90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ab0ca50790f216f0526e8de169ba8906d810f61ff0443652abb0f51ddf85109"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd2db00d38c159087a47e9d93c61b46adb2106f457192ee3d92ca7f6526350c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "034b42eb98e84f539d25b5492c9955e50f19f5aacee8d439a781525cec005b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f31d4d5137e8d2512cdeae0cecd761e8c466577db53d3a4f100007df89f5941b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ipfs/kubo.CurrentCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipfs"

    generate_completions_from_executable(bin/"ipfs", "commands", "completion")
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output("#{bin}/ipfs init")
  end
end
