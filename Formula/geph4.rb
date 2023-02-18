class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.7.7.tar.gz"
  sha256 "a1c17ef8235eabde4a9e0c8d8354ba058d3aaa97add4fa220efa2113fa32399d"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69b8da0ef36e735d82cc82379438928c07936525e72d376d15548c348ece3a3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98c215ed0d9ed6e861f3818ec68a8b4ef05b7ca50473145f869a27770809d00d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2408010424a1f91bf81b217f082ebadf506bec8ba5b1468d40c50f45e42b6c2f"
    sha256 cellar: :any_skip_relocation, ventura:        "f4e18fb3153dff518e9eda9923af4d0d5415641f07def791b9175f42f7790fed"
    sha256 cellar: :any_skip_relocation, monterey:       "2c91aae889f5c60de15f251ecf04a25da1ddae9338f332baf6fa8272d77e843e"
    sha256 cellar: :any_skip_relocation, big_sur:        "23b6e230b4688d2c147d63ce3042723b69b5ef612a714cdd7e3fb7b18a3776c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfa84e9d1d18bf24a4628067b6381fddaf68fafa595b06a689d8fa8db4b5fc44"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid username or password",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
