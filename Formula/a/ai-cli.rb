class AiCli < Formula
  desc "Generate images, video, audio, and text from the terminal"
  homepage "https://ai-cli.dev"
  url "https://registry.npmjs.org/ai-cli/-/ai-cli-0.9.0.tgz"
  sha256 "937612e19a060035560b790a2267237638a50834f7cd7bb4f003a0a395a7a0c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3974252e68763325964877fe753b5554e03f8316bdbb3aac00797ac393a45f55"
    sha256 cellar: :any, arm64_tahoe:       "3974252e68763325964877fe753b5554e03f8316bdbb3aac00797ac393a45f55"
    sha256 cellar: :any, arm64_sequoia:     "3974252e68763325964877fe753b5554e03f8316bdbb3aac00797ac393a45f55"
    sha256 cellar: :any, arm64_linux:       "b202b9c7487ffe43a411d91efe4ac5f663d4d9020586c988753bbfc08e090c1c"
    sha256 cellar: :any, x86_64_linux:      "ecd615b2a7915b25485725138f36071e8476b554284072cc0db04b4e1f5d1530"
  end

  depends_on "node"

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/ai text --image #{testpath/"missing.png"} describe 2>&1", 1)
    assert_match "could not read reference image", output
  end
end
