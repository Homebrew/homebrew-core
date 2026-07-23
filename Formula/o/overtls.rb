class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "d0ed3ae88721e8ae2a525059a81ce29991af29de920bf580cb0999d0a7ac288b"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fda28597d6920091f94c14db824fbd97df3afe9a98dc183bd44f3237dbad919b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da15364e7a73988dca21949b9d7e9e85f973ed72fa59633e1743a6423255d140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d14d234f5b71972fa8e97db884a8c0d4372dcdd205f6890ca37318f148fc7383"
    sha256 cellar: :any_skip_relocation, sonoma:        "49e09a26a2fdbd490240cd47d81664b935e4d23a58396cab6ab4ea59fccf435d"
    sha256 cellar: :any,                 arm64_linux:   "c5a4cf778e22311f09c438047d7d263464ff962cf7439f4cba4de7a0f7770504"
    sha256 cellar: :any,                 x86_64_linux:  "5a4ea64e3da720373bbeae7907a5f5747225fc9a584c4ddb5a13682c154aa6d1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls-bin -V")

    output = shell_output("#{bin}/overtls-bin -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end
