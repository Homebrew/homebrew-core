class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/v1.6.1.tar.gz"
  sha256 "8a40e0d4467de305ecb0733879aea2c087270348709e1d645918b48a74309572"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d16b290e3dcecf11deb00f75a22d73bec4f7bdaeea37dfda0889512a315e4aa"
    sha256 cellar: :any_skip_relocation, big_sur:       "e37d627fb16cc38a99d995602ab0ca4e58c6582df9603f217dee2bfffc663825"
    sha256 cellar: :any_skip_relocation, catalina:      "3a026ea42ce37e066475fc4602cfd68b919a1fc824f4a00189c79e6386f2c250"
    sha256 cellar: :any_skip_relocation, mojave:        "a834cc71a076e48c8a9986487d20bc100bbc9fe260cf10bf7656c92c95e4fb40"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X github.com/miguelmota/cointop/cointop.version=#{version}"
  end

  test do
    system bin/"cointop", "test"
  end
end
