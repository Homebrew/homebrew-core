class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.20.0",
      revision: "b8c47250026a318d9b1496d7dcea6284355db140"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e69dc9bf0115eafbfef1dd50f155e730140ca9d5d93795a9d5c28956b934ea1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d31f4cce77290d62b3e3088c342e96a57f106d62ca04c344427935ea8e6f6c41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "999a4add561bc23ea840ecbdcc8f5418bbac0f7f1a3975640cab442b9d2b44ba"
    sha256 cellar: :any_skip_relocation, ventura:        "5a9585f4fd8618045c263627e4b8cb66642da9a744842b1fefd6e076dd7b980f"
    sha256 cellar: :any_skip_relocation, monterey:       "e37162666f02313a033ae2346a667cdc55790c4a9866aa3ce19d64cafd4841b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e83d94a5a2e0aaae9cc1865a3b4d90bf08a044130378ad5bb288bf22e670c7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0d3a25e1e3e56678292a7d4e8bf37b4a30b7a12509a1cd634389646f52970d8"
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
