class Havn < Formula
  desc "Fast configurable port scanner with reasonable defaults"
  homepage "https://github.com/mrjackwills/havn"
  url "https://github.com/mrjackwills/havn/archive/refs/tags/v0.1.18.tar.gz"
  sha256 "f8fc24c2c2035f40566e415dcebfaebdf372c225fa1d4d0c997a24fe862836e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81679171ca26be620ac282223f283f4f8d59acc5f447d649f1df8a2159c8606a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "178633eec8a627affd1aa476d6e2250aac58fdcda62b4c5e96dd498b2b2864d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89b92e5a474ae5f7d1de6ae4be3c63bdc94dcb8bdb21af2317196ee26d2b9851"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe6520c7f5083e07d9ba7ff39f00d2624fcb0352848f47f36f3a7095fc82da59"
    sha256 cellar: :any_skip_relocation, ventura:       "b07884df01031dc58f2509b7059500a7fcde85715f67a566f7284b2b6be9bceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5610e013072bb4b12a461081266fdb3e180fddc2673fa104b2987d6fea3e9b11"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/havn example.com -p 443 -r 6")
    assert_match "1 open\e[0m, \e[31m0 closed", output

    assert_match version.to_s, shell_output("#{bin}/havn --version")
  end
end
