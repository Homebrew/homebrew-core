class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/findomain"
  url "https://github.com/Findomain/findomain/archive/4.1.1.tar.gz"
  sha256 "7c513a61218301830f52f65f71cb09b081a859f3cab06fa974f22e9692dd713d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "483824d17552b08b53ffe68b82ebb05cd3b8e967697606de87c7da53bd0db535"
    sha256 cellar: :any_skip_relocation, big_sur:       "0a024f4ac2a885b7a00cf896ed64dd517bcd8bea4febf9fd88c2db055f860a76"
    sha256 cellar: :any_skip_relocation, catalina:      "f15811978851a78b040aa4baa087ad232658a00d213cd3f2a521daa6afc23a7a"
    sha256 cellar: :any_skip_relocation, mojave:        "0f00d7b449da6d3e93ff843a726324bdc291160989a18950921d854bd1ac13b3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
