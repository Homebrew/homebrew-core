class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/lune-org/lune/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "10d9b3ae927d77307bb057fd8ec0ff396307ee9826c240ba9779fdeeb2f2eed2"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "812b4d3dee3f3c4f404921c47195fc2f3d91161781353a2bf81c2def617f9593"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca136c360df3642d5e75e8bc77ef66bc8e729ac6e9b113a2d2eecb5a63b641d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e70409c082177e5d2235b3a7cc7fd1e99b23782ee29c527ffdb9fb87e93d11e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e592efea970d041c837ce10841d7436b3b23cded05c17cf1ed67191ef9600887"
    sha256 cellar: :any_skip_relocation, ventura:        "74bb595146b47bca8c50f6a191ca117e82948c514040a58a7690e10cb7898656"
    sha256 cellar: :any_skip_relocation, monterey:       "42927bad14ded2c671f71cb2b8f7941b3b217bdb5da642479b21780394d5dacb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78918870663bfe9c4711f86142f287ce057db4328d6339d5a3df9c968a69a05f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune run test.lua").chomp
  end
end
