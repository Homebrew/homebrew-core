class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "681d15b889ef06821864926c33e1916cc603d4fb87f550f2324648e747e7e4cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fecee8988be5cd9ce6f4e4eb0e980cad189bb6641409a1dfd32c00866159d29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fecee8988be5cd9ce6f4e4eb0e980cad189bb6641409a1dfd32c00866159d29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fecee8988be5cd9ce6f4e4eb0e980cad189bb6641409a1dfd32c00866159d29"
    sha256 cellar: :any_skip_relocation, sonoma:        "82dcf717e84ae5e45bba60d1fdc4b3b4c891dc5a2b1813dcc98a3584982bb5a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d473bb1052ecc27cb75c5449d2241d42d8faa5ee4738c3768ad97b0e69cc5404"
    sha256 cellar: :any,                 x86_64_linux:  "e8f04c55fc4db1a5579c93c796712091778916f46bd5278557dc67e82f9dc4b2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"mercury"), "./cmd/mercury"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mercury --version")
    assert_match "Authentication Status", shell_output("#{bin}/mercury status 2>&1")
    assert_match "Your dedication to modern banking has not gone unnoticed", pipe_output("#{bin}/mercury hat 2>&1")
  end
end
