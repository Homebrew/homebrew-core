class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.319.tar.gz"
  sha256 "5a5e2292971659e175b3f5f5bfb314e6f373e8e726652a4cdb576839170d1661"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6631f44ec4f5dd42127eedb5b503f6f2acbe0aee823d5ce65b005228d2a4ba3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6631f44ec4f5dd42127eedb5b503f6f2acbe0aee823d5ce65b005228d2a4ba3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6631f44ec4f5dd42127eedb5b503f6f2acbe0aee823d5ce65b005228d2a4ba3"
    sha256 cellar: :any_skip_relocation, sonoma:        "83352d1d066d5a3432c95bdb5621a0572defadc5be17c0b981f4bf38ff6d4c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a550fa188baaa3bb9bfd2663b2600994f50a8e668314757a82dd4ec25c98f661"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
