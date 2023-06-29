class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-5.15.tar.gz"
  sha256 "7b3ffcef9caed1762ee4e45fe1a93a44dd63586c6e1a4d27f74db7cc992896e3"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7149d9ed2e76ddcc15c8633d4d36d0016586e102936fcfe6d8d2fd990b081143"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7149d9ed2e76ddcc15c8633d4d36d0016586e102936fcfe6d8d2fd990b081143"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7149d9ed2e76ddcc15c8633d4d36d0016586e102936fcfe6d8d2fd990b081143"
    sha256 cellar: :any_skip_relocation, ventura:        "cf1c805671dbf2e4ccd95fe33bbb8d6661573a0c1527e4e24c788e3f57d6ebe2"
    sha256 cellar: :any_skip_relocation, monterey:       "cf1c805671dbf2e4ccd95fe33bbb8d6661573a0c1527e4e24c788e3f57d6ebe2"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf1c805671dbf2e4ccd95fe33bbb8d6661573a0c1527e4e24c788e3f57d6ebe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c775c27013fc5f723cedaefeeaff4bdaa7d6ea2d4bd9b214bbdb767394c8ff66"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]
  end
end
