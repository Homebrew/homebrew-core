class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.19.1",
      revision: "958e586ca7ac4580bbe3789bc7ea1a2c87bd33ec"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ab39d11da109cd09b1b47d17826c6daa9a2777d7eb86633248e8167fcfa5008"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "070a75349089fbd77e1a73596449ac6ece54364a0563dcce7264b50ef94597c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25cb2e01941da33e8f2b629abd9805e95f48f4f01d5f75fbc366323cdfc25a4a"
    sha256 cellar: :any_skip_relocation, ventura:        "9b8926c9de2736e3a044ffc40255daa1a80caedc775326b9d4bab537cc9b0005"
    sha256 cellar: :any_skip_relocation, monterey:       "1522411faafa43d62f81e8176a3b3abaad7adf8a8be2d192155c0185a2b08d59"
    sha256 cellar: :any_skip_relocation, big_sur:        "785d6ad2c17abbd96a7326ac04f9bbe208fdd7cbef0da7d02156b08ce70ab146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "893232c3d32de20ca73cc406f689ae9dec31bc244c7237e9766eaba6b9d60c5e"
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
