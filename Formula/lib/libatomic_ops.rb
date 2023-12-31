class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.8.2/libatomic_ops-7.8.2.tar.gz"
  sha256 "d305207fe207f2b3fb5cb4c019da12b44ce3fcbc593dfd5080d867b1a2419b51"
  license all_of: ["GPL-2.0-or-later", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0656f3850ed197d3bc92adabea46679ff74785393166e0c0c507ce794687e792"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "186e0da537cb1acb541a2e30fbf504cbee435e2a545b916f2cdfe2cbe215446f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2438dc4e1e5f181153c8d3dc4322479b005cb62332dca92d305ef1b1d03c6294"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8ca9d29909dbebf999ac0c27122fdcf119f76d5c884b62916e5e0ecfe235d08"
    sha256 cellar: :any_skip_relocation, ventura:        "639fd6de155ad0f4a0ba53bf43c0a286eb84ac8dddc6695eeb37d850452a1a7e"
    sha256 cellar: :any_skip_relocation, monterey:       "24988ecc4bbf4449f78fa70a3703f1415eddb879a91dd81fc6b2e53fedfdd81e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdf260b5bda03963ab662e75b08bd82b11188bb9d87113a0c0a28eb0e9dc5564"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
