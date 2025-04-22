class Precious < Formula
  desc "One code quality tool to rule them all"
  homepage "https://github.com/houseabsolute/precious"
  url "https://github.com/houseabsolute/precious/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "163b284fff7b723f9645312d1a45fe7149885fa40269c6ee92866d46a1da177b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/precious.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b457ca7da867684a3c0f3604cdb058d4817f2371ab90804a45bf8b1511d80de3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8ebd1903d575ace899f49c82c6a986aae358b53442e688beb84d27caca8e7b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a07763a1d8571b9d212a65decd5d027e70d1f69ae53f8ad22bdb618f054a6ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "f59b2871ebbdf1243e0fe21cc311717d9519bfd87cd971ba89d1c7450cf2c866"
    sha256 cellar: :any_skip_relocation, ventura:       "bc0492d280551835ef5e9d2fe17dd11c0c89f03a95d0b40c24477b40862e3a09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97803d50efa42e499787e243a4d415fa628eabd04850920fd5cb5cb5f84e66a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f065796d18580e7962b43e1dbf6f58ce2e1e948ebd27c8bc8493d1546c271642"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/precious --version")

    system bin/"precious", "config", "init", "--auto"
    assert_path_exists testpath/"precious.toml"
  end
end
