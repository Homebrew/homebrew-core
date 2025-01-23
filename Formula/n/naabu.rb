class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "fd0b9b5116dc13fea8e3c9403e1f20b9c2763ed25879ad9bc8f303fb71005ba4"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "493162d00eaff9c78244b82e1eaddfb948a7b7a56316b57f2d44e6409a0369ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5c80f6e0088b64b7484bdefd0f1568842ae1b469a69081674ea78eb666f5d87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b17c14c1268117014ad92f2c5b1ea71f7e146115000ffdc17d748915a2a879e"
    sha256 cellar: :any_skip_relocation, sonoma:        "09d67d77654175dc69373cad0dfb1fb11a8496980e5d749454040f6c54e486e8"
    sha256 cellar: :any_skip_relocation, ventura:       "89af41be819003954e2f07032f52f97c2799d177c9ae50a8fbeca5b990fae5d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b3333b2eb40e5ee7cdb08f369e3d20117a68415c567474f7dac2dc53cce3260"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/naabu"
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")

    assert_match version.to_s, shell_output("#{bin}/naabu --version 2>&1")
  end
end
