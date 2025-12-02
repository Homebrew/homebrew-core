class Bcal < Formula
  desc "Storage conversion and expression calculator"
  homepage "https://github.com/jarun/bcal"
  url "https://github.com/jarun/bcal/archive/refs/tags/v2.4.tar.gz"
  sha256 "141f39d866f62274b2262164baaac6202f60749862c84c2e6ed231f6d03ee8df"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "158b09c6087e82d87d6d4dfc3f68354e863c4f1a20c491128cdf7c16c88ddbc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "43837bc1f22892876291a80a28d09583d6e3a5ca91eb5604682a7bbc1e85289e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ed08fabab9e6e7b2dfcdeb4a3e7b6945077b9a3b3922c436a7b9f38807e1137"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a4d8cbb8feb1e2fe5b066ede0ce26048fa9d005f8a8df6fbd52dfb79a94f743"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e02378e4f54c79747e0c4704a10f376bb4647fab48bbab0faf10c9b14f0d294"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a312da829f663fbc969ce1421c967bf301bb7a2fdab86d30f14266dfdb1731a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad0b047f53f3d0e29e52529aa8b147a91b2c66cce71eaed5df2025355f491fae"
    sha256 cellar: :any_skip_relocation, ventura:        "76325966b3ce420ec26e3baa523a903f227a087d102e7d69f9865fed3d11edbe"
    sha256 cellar: :any_skip_relocation, monterey:       "b067832e1fcd2ca0d46b4a73546288e402c50b0dbf5c10301fd2930a30669ab2"
    sha256 cellar: :any_skip_relocation, big_sur:        "58e835299adaf40b94a77390234d9e80a113d57efd18f5249d9aabfc9c7ac386"
    sha256 cellar: :any_skip_relocation, catalina:       "f71f837270d535a16447b927b4d3c32bb810e61d5da18c9476c7f04543684ac2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d206903ae5ee9b92914d37389c399929761b0b3537fbfb8e2c8788d6b99312d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f559a27314fb98edb8c31718cea5f817cd9e891c395d5e49387d4799d414e6a"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "9333353817", shell_output("#{bin}/bcal '56 gb / 6 + 4kib * 5 + 4 B'")
  end
end
