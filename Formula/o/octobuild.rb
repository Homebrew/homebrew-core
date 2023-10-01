class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/0.8.0.tar.gz"
  sha256 "033341ae371c1b62294d3c6068b6737f9d37bcba3a708fe3702007a7505e21c7"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10ea936e9fbb96b2cc8249156936c2d43bca6b494037ee2c2fbb766438532eee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d92ff0acd07349aa767fa89283a6a9420e762d974c08d31df60363506a897aa1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aebe8d1c8d2c7137fe4af4b4018c822d77465189231d451dfadabf7fac1086d9"
    sha256 cellar: :any_skip_relocation, ventura:        "41706153fe80d676fb8bcd4662f14893190328a0c09d3ed432cc9235dc19549f"
    sha256 cellar: :any_skip_relocation, monterey:       "1a13351a1d4733591a2a340fef9c023f03d9d393dabe9fdcfb4a89d38f3a62ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7de7f950cb6edc24013f3b99e1f8a4cf578115d46b077a4614e96612f725e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "133f9be1bb0225d0e3675b17851d07b7cbdc34b22b7fda8e7520ca9f7c726896"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end
