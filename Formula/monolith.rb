class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.1.0.tar.gz"
  sha256 "966dadf31f174dcc21a73110bc432ed05789cef899ec3aaa035d9e5c2b17258a"

  bottle do
    cellar :any_skip_relocation
    sha256 "c69cf528cce76bc4f2885d0273ebea9a635355659532dc6c21988b95856d3646" => :catalina
    sha256 "708795bf4df8c960865e13338bef62e99b485a46a695c109335b6674ee90569f" => :mojave
    sha256 "297bbf8d263e194da2c6b0503a6d77eabc88de1b53bf3727f940831687c529a8" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/p/portishead/dummy/roads"
  end
end
