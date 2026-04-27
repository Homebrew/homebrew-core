class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.33.tar.gz"
  sha256 "7bef6e39319fbaf8dffd58c816ea1132aabea18fa65131990eef28527ca01bf5"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a8230e4ac617c8102d6ab612ba8d77d98146208a7907392d90c02ddc6e0aac1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8baa627bebdb097831faea062547eaa666334bd9dab92732b652ff3c29bfd732"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65f4864cc836afdbb6db0f7325b23d861b88a8fb50ee14396ce1f146b2effd98"
    sha256 cellar: :any_skip_relocation, sonoma:        "4eb94f4e6ef47e956883cb79194f030529a3f29ea685366e52d01d230ffe0ea7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff288dc115bb7b79df00b8c22aaeff705251315ee4ca56ce2b61eb3d7f9ed660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10055f052c1d27ac8aa1e57deafc68020fedb406d65b9c68d9bd72fa408a948e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end
