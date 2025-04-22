class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.15.tar.gz"
  sha256 "e416a7b37e0c40877c9052c00fe8a7215296cb4d59be696fd0909bfb4ef72724"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99f4f7eafb670b179f8bd879038a7ecbce4079197071d2435ae7d6d84949d3bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84a29cc86e4ec0a7cf5b50c0ac3367e1e87b0bf6e9fe68db66bb277621f28686"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03c3bdf08e121c5f74f68dd80bdfa48d29f1fd1c699f548d018a7ce98bafac63"
    sha256 cellar: :any_skip_relocation, sonoma:        "8835c0b097541cd1a4b103cd3f2dc92e0d00b110a33b1c9b13988d4c6df6b7ad"
    sha256 cellar: :any_skip_relocation, ventura:       "0bc0ce815a2cf8aaa4be284744a6bd65ecd567862a923a5d7acc30ea022c5a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9afff62ff4144c5a83fa1246ec8771fd691a75c8ad02a6c3fec34b465861bfc8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
