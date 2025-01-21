class Katana < Formula
  desc "Crawling and spidering framework"
  homepage "https://github.com/projectdiscovery/katana"
  url "https://github.com/projectdiscovery/katana/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "f88acace9ceee767cf15a5212ada2ef0c40dc1e4863e4dfbeb4418f5def55098"
  license "MIT"
  head "https://github.com/projectdiscovery/katana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb97945db87b8300094bc9563a7556149c2a61be37aeda5874e5797ca973c2b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac0aa96a1804ab6cb7b575c2352fdee0a34ac46a74e762af2429cc99f212e7b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c439b24c21960c83458a81abc22005b250486ee7d509fac9c55e4b51ec63b4b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "666940bdcee26b77aecbf423ef8c42561fdbca3ee07372869bc4ea451112cc40"
    sha256 cellar: :any_skip_relocation, ventura:       "15782ff5c3f4fa84fd9a40bd4283dac1798be4dd8d76b2db88013420fc9e7991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0b5144fb31754168c0f7b0f8f0714c5372242a84c7ba0f72d5fc810cf8a1848"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/katana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/katana -version 2>&1")
    assert_match "Started standard crawling", shell_output("#{bin}/katana -u 127.0.0.1 2>&1")
  end
end
