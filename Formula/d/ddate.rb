class Ddate < Formula
  desc "Converts boring normal dates to fun Discordian Date"
  homepage "https://github.com/bo0ts/ddate"
  url "https://github.com/bo0ts/ddate/archive/v0.2.2.tar.gz"
  sha256 "d53c3f0af845045f39d6d633d295fd4efbe2a792fd0d04d25d44725d11c678ad"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe29278ae4f80f7c8db1de60b5aebf6d80b309b8b3d7cf866f1d092f7a4c518f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "967dbd56914c5b0d578b93c936f311f2af91dade23abefb8d3e6d6d8814b142c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f45b9a3b64d14ae95d1aabb359535c7394fbb9781618992e0d8987009d1b306b"
    sha256 cellar: :any_skip_relocation, ventura:        "dc6a83d4395ba0e0cc54890798b9dec02958912ad7f17fbadf2ca46c8236e9c8"
    sha256 cellar: :any_skip_relocation, monterey:       "f8c316d4c6b48ac80d5673f55bec768501c725d500ba9b926fdd347adf55cd79"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e7f00a11029e70caa333a3c33367e564631fcea1d08b36f02437af7b03f810c"
    sha256 cellar: :any_skip_relocation, catalina:       "2b9be177e37cb4650bae50a9527315e700592bdd8a5546cfb7b40cf201bb680c"
    sha256 cellar: :any_skip_relocation, mojave:         "bac9bcfe773de4c34915a353fe6f8808ac26f8253d0da9d43ab9787b4988ff44"
    sha256 cellar: :any_skip_relocation, high_sierra:    "31a72f135768fdf09ddc40539e3860e3489cf478cca07f6af71d8d3428447a78"
    sha256 cellar: :any_skip_relocation, sierra:         "61be1f5fc044574ede464807fba1e092bc165932a909a357f5cd71b0cbfd4726"
    sha256 cellar: :any_skip_relocation, el_capitan:     "fe87fe60ad1e8cbff1ebbcefd8be0f6f8ec87013a91e6385adbde0aebd45edea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75baa9706ec0453896edf597bc5a9c52c012ea9188555654f698794f578d9f62"
  end

  def install
    system ENV.cc, "ddate.c", "-o", "ddate"
    bin.install "ddate"
    man1.install "ddate.1"
  end

  test do
    output = shell_output("#{bin}/ddate 20 6 2014").strip
    assert_equal "Sweetmorn, Confusion 25, 3180 YOLD", output
  end
end
