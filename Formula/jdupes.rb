class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.21.3.tar.gz"
  sha256 "8992d0ff1fe135c685063ce3c9d69d54f1f19f1b32845e84441f888218063cc0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91125c9f9c88890f628da43fe2f6a84b565bbadc9ea5069f62b291192c89b580"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea07b94575abb40334b7d66973ca0ccfd25f53b1795a7d7bcec3834472543e2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0b8e817535de3452d0ac4173083ea744fbe26ad5379625cc436f3cc9800e8b2"
    sha256 cellar: :any_skip_relocation, ventura:        "101bcd3c54891287881cf761178748a4969503e2c11e1de82f8d983f8d3a78bf"
    sha256 cellar: :any_skip_relocation, monterey:       "06ca6557dd85a744c0efcdfeb8ea1fb47b4e97aab72c449ca9fcee16daef7b80"
    sha256 cellar: :any_skip_relocation, big_sur:        "e36e3547d43cfc8ce6865f19baa96b2cac5253e8b658abb76cc7de2ee1e90ef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5648542893455f09f8b31b7b8fa30fb617bccff696a6cbb7e84dd0d835672ea0"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ENABLE_DEDUPE=1"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
