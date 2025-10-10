class ChaosClient < Formula
  desc "Client to communicate with Chaos DB API"
  homepage "https://chaos.projectdiscovery.io"
  url "https://github.com/projectdiscovery/chaos-client/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "322f0c200887c2b0e6c412c70ad5de741a30e7687028966cfe26aa7534218369"
  license "MIT"
  head "https://github.com/projectdiscovery/chaos-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a285bcf99b8a399a6c8c64334ebd2b381373c7e3b0e0f25fe4cc6872b3e47ee1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0fad8ac3817b56bacd3383d334d2a33c7542dc71ee557afce144a82d759eac5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ee39f40b5e740afd156a0ef79b7cad536369095b04ff72a75c958f50c0bce92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a847c1647361de8fe446c786e5954939b70d4bdce2fba6b191da934b3f67c01"
    sha256 cellar: :any_skip_relocation, sonoma:        "beba47d0434fe37e817143e1f41e8025678220d0e428f4347fba7d11fe6951b8"
    sha256 cellar: :any_skip_relocation, ventura:       "d0d8eeea7253bc21784261ea3b5127928bc9b0eb174291c879094378c548c4a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d1ef6c9c127554af8fd43ab70371318ea225d9c9689f18dcb56e2e78b749562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d4734d00dfa7a505a34db36e3121a9b8562da89f79923164f65f742fb50fc55"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"chaos"), "./cmd/chaos"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chaos -version 2>&1")

    assert_match "PDCP_API_KEY not specified", shell_output("#{bin}/chaos -d brew.sh 2>&1", 1)
  end
end
