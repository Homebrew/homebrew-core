class Jnv < Formula
  desc "Interactive JSON filter using jq"
  homepage "https://github.com/ynqa/jnv"
  url "https://github.com/ynqa/jnv/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e83ca02d02fb98ea90179d5436e6425e18c0c47d8d2eea529bb25a1059512477"
  license "MIT"
  head "https://github.com/ynqa/jnv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c2af8626ff805bb08739b066dfa6f4411935b2b45a6c97f797609cc828fc663"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc8410f97add619d0a875be0d6c724a2115071c7c94f575b600c772e40ba345e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6e89328a6a81cf58ac8425fc1eff44738de7425eb41a7a5ac08efe20f7d5875"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b208430040fa188f1e6548a04ceda5f43e2e9ea0368e861173ae054c810ee58"
    sha256 cellar: :any_skip_relocation, ventura:        "8edc2451a86b287d5c43fe2546ff3c94f8eb2ccb740e27e58ade4b90d28ce98e"
    sha256 cellar: :any_skip_relocation, monterey:       "72fa2e797790d3b4c18c0b41f6814ea212bc87288f242eac8980f7a167a55307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc47f97b0e34a2ce29df201979a5ee505bde2cce6256724db61368633b4e9ba0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"jnv --version")

    output = pipe_output("#{bin}/jnv 2>&1", "homebrew", 1)
    assert_match "Error: expected value at line 1 column 1", output
  end
end
