class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.27.0",
      revision: "59bcea8783e4117d56aeb81685ce33b8ddb13a1b"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/kubo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e31b3fe92b4207b14469e2a9e5c62141194da2e11733fd2edb9158d80f48d6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d876e9663cd3f18975dc5cceff006c06cf131417d0ae6c14e9c1222f4f2cf9b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e520f4bafdc83308165ac52713cf6a86eee689750c7c2a52c3cc68a330e0c96c"
    sha256 cellar: :any_skip_relocation, sonoma:         "fde102085a752671e3b8b48b2828cf4bb517e68df60ec3fbfb5e94ed0c81f68c"
    sha256 cellar: :any_skip_relocation, ventura:        "fd1b6bf78a3709991091e8850a09cfcf37c63d3a717c3d66e0fb715aef285a62"
    sha256 cellar: :any_skip_relocation, monterey:       "6a778a4712739429ec44252c566c74d9a198d756d73dbd0c212b69dd3652f727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd89ebcde1e0a1354a2f7b9d9b1cf9385b98e663961c01f60c2fa4a451933ce9"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "cmd/ipfs/ipfs"

    generate_completions_from_executable(bin/"ipfs", "commands", "completion", shells: [:bash])
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output(bin/"ipfs init")
  end
end
