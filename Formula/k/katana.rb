class Katana < Formula
  desc "Crawling and spidering framework"
  homepage "https://github.com/projectdiscovery/katana"
  url "https://github.com/projectdiscovery/katana/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d95921d3a4f01b5bdc60416f943d67b1622b222066e3e701f873d2947483b0a7"
  license "MIT"
  head "https://github.com/projectdiscovery/katana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa484d5954f6893e54c293585b5fb1e3559f2e8edfe4f2b56eda906579c0a78c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41df491c03289f9d1beb2721f4b30b3a6d6318c66767c9b3032a2dad7ceeb898"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46f65b6b0edea3283808977d6d19c1c90773a1ed9cdc5e3762e46ad180d676c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "80c74dfa43406c49b1fb1ead54677874e009c3cbb015163708b6fd1aa92b9474"
    sha256 cellar: :any_skip_relocation, ventura:        "21a290a015e0b459cc7b70ad4070295397b5dc0a57247b8ce60699e9a2ed6896"
    sha256 cellar: :any_skip_relocation, monterey:       "2f402466439215ab417489748da7ab5b6fb1f839c7d35a426bb0ea5d21831e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5f8323a33a779798462064082e4c76b0fd5645d067d737b2f8bea056b836813"
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
