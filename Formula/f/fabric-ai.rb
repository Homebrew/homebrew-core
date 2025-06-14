class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.203.tar.gz"
  sha256 "78a9846014b46544feec9014dd455ea8c702b4b7e060a29bca744585c40ccd36"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3713c0d4626fe240eb56aab91a2c1e32a78d01fad8d73b63277f8b9a0f2d44ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3713c0d4626fe240eb56aab91a2c1e32a78d01fad8d73b63277f8b9a0f2d44ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3713c0d4626fe240eb56aab91a2c1e32a78d01fad8d73b63277f8b9a0f2d44ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccc498a2a0a999c965cc259bf3b69b924f8c38ae132ee7941764452c692cd658"
    sha256 cellar: :any_skip_relocation, ventura:       "ccc498a2a0a999c965cc259bf3b69b924f8c38ae132ee7941764452c692cd658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81ac6faa6fa96b938b0683a9721d9c23dfb656cb28769600cd649225bee58a44"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
