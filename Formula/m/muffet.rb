class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "eca6234caf3d278696a969f630c1b62b634731d247b16474750c9fa75f1128c3"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2fba005dc5480c45438c8715c01a8eb792ceded2fe622ed01126aad71cfe652"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4da53b95da11db4afbc38f15eb901eb7483fe6f4e31b880b73bbea1d2517c4ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1efa606875f4f228c550ba98ec178c60887bcec41638440efe3fa1b59994ead"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0ac5eb5a6a32b76c80de96e79efced9b36e1962d0458144f4cce1d68e33f47c"
    sha256 cellar: :any_skip_relocation, ventura:        "795dc4c58e54404ae020a1046a86059f21ca65e51cbe73113897d5ec7a693cd3"
    sha256 cellar: :any_skip_relocation, monterey:       "07cfb063b6d40b05be40eaf5d27464cc76f474cbbfd8a0b36582f2c1917891fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eae28aa9eafdd5d26f7ee4e915a313265f41dc09d6065728e0680ffdb03a60c"
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
