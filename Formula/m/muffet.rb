class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.9.2.tar.gz"
  sha256 "771c85fe44ad6e89a457e72d399f81146e48d2abb8ac555653bf4cb49941aa42"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98c0dd8ffe231d6dab99755c7ad7e62fb3d3c702dc967e6ce5fca3f018fe0a16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57212ba3ad2507992422c0b2e372bd9ab29cd3fabd5a8dae71fa0a34bb49036b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57212ba3ad2507992422c0b2e372bd9ab29cd3fabd5a8dae71fa0a34bb49036b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57212ba3ad2507992422c0b2e372bd9ab29cd3fabd5a8dae71fa0a34bb49036b"
    sha256 cellar: :any_skip_relocation, sonoma:         "668e8c672202550fce887b1f60ba4a4a9d41981d2b8210cdc26ecad0f296e50f"
    sha256 cellar: :any_skip_relocation, ventura:        "3eece1269bf5d1090d2b08f4e4a1a97a6cdf70489ae2ef021c5c0a047c2266b6"
    sha256 cellar: :any_skip_relocation, monterey:       "3eece1269bf5d1090d2b08f4e4a1a97a6cdf70489ae2ef021c5c0a047c2266b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3eece1269bf5d1090d2b08f4e4a1a97a6cdf70489ae2ef021c5c0a047c2266b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d078fe2eeead6460c88e2a4e2dccdf417be18d202ce8a46c036d7fdbb6c16632"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://example.com/",
                 shell_output("#{bin}/muffet https://example.com 2>&1", 1)
  end
end
