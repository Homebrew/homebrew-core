class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/1.2.0.tar.gz"
  sha256 "6639fafcbcf4a8f680a4a15d104fb06573aa2e3ed354e478a70ea56555c2bcb3"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "065d1a9910e8fa5056493eba7ec09932ff7b687b03b34ebc327ad4540f038c9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "576e7592d5dfe5ecfc3ba99661ce2226d958b685b41f56e42ee5bdebf9e97303"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54027df8727ef399b7991d291301249d7508f2f1fb436e4f9b70ef636271954e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bd0a62affad79d84f708335e8a6d20373fbbfecbde6b32bef2b679b7959b8ab"
    sha256 cellar: :any_skip_relocation, ventura:        "89875850c0001e63585350523ceffdc468c652a775869e4b66b454660efe9bef"
    sha256 cellar: :any_skip_relocation, monterey:       "7c0fb1cd3760d1157168f8db08e5a09579fe353ba61eb488c2702807c1b28ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18eb0bc44670fefb140cf04263f0cac64b6c4e1d0c8eda0aa84b82a8b231cc90"
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
