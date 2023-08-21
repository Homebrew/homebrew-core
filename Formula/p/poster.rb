class Poster < Formula
  desc "Create large posters out of PostScript pages"
  homepage "https://schrfr.github.io/poster/"
  url "https://github.com/schrfr/poster/archive/1.0.0.tar.gz"
  sha256 "1df49dfd4e50ffd66e0b6e279b454a76329a36280e0dc73b08e5b5dcd5cff451"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3502b06b6c852fa6ba935acf4a862b72987beff8658b37a11f40cf349acbafde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33532f868bdc3667b1be77b533608c5f5837f19fe5683f0ee5d33ec945748e67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebf74df79fee5779f0a6631c938af2db579bfdf27c077fadcca06f21579bfee1"
    sha256 cellar: :any_skip_relocation, ventura:        "fc8ca26f680993d3584c3aaad86a2b9f3ae56d199a0cc614fbb1f93fd27493aa"
    sha256 cellar: :any_skip_relocation, monterey:       "fa63cfd184e101b839afd59ff181bd3e089925ce5a8b93936b579249dd08f955"
    sha256 cellar: :any_skip_relocation, big_sur:        "1dfc4b7649d3ad9c7b22693d9dd966c395a11385c6f5ecea07ab879972f5845f"
    sha256 cellar: :any_skip_relocation, catalina:       "e0afaa430ab84862c5a481145e73affbb572c008c1b40d6b8cd93eb465163b4e"
    sha256 cellar: :any_skip_relocation, mojave:         "110db1120ca8bcf6b68f14cfb24cf92f0027b6897fb9a44a8c067f4feca54182"
    sha256 cellar: :any_skip_relocation, high_sierra:    "74db7055649cd3f68316b99db48139641f916b4434008300f2bfcd1146f92c77"
    sha256 cellar: :any_skip_relocation, sierra:         "caa5474e5d7baf13ae6495c01a7530146d55531e41c88a469b0e44ee892c4be4"
    sha256 cellar: :any_skip_relocation, el_capitan:     "07702fc6f1d43a3875637f8ff9d3509d6eb913abda301c24c23d824a76a858b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "623f96d36fc59df594dd8ed5e0073b1d2892e083176346e93821436664351909"
  end

  def install
    system "make"
    bin.install "poster"
    man1.install "poster.1"
  end

  test do
    system "#{bin}/poster", test_fixtures("test.ps")
  end
end
