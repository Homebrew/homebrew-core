class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/v0.10.3.tar.gz"
  sha256 "f044d8a019a6bb3fdc553bf8e67bffa566494bccd85bad35130ae71faa7e1aaa"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0fc6ffa92409d61eb332536528fd3a95eeca7b89b39d1ca8728966cdf33cc41b"
    sha256 cellar: :any,                 arm64_monterey: "af7b55b5810d0be43092aba5f73cca3efdb6fb75401ab21437f82d9efd4cd3a1"
    sha256 cellar: :any,                 arm64_big_sur:  "6680c5c683204f43d70cdc95ea1c95a0681891c7b98b26bd122c295865e47765"
    sha256 cellar: :any,                 ventura:        "b63cd25312cdb4347bbae132cd11aba165f3cf3c105090cd791cddd8c9e269b4"
    sha256 cellar: :any,                 monterey:       "99e4bf24b38de19bbb7bfc2abaa56f8c8e7f278a8dda87b02f9ab6f16461e6f6"
    sha256 cellar: :any,                 big_sur:        "32e042c3ba71213f2c258f0d2271f89128ae9c88c6c205087ad322948e73364a"
    sha256 cellar: :any,                 catalina:       "bfd2cd6b582b0603bc0e102f97613fc0989f16988d160eaf2ae46d1187bc29d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f8ebef7040461b41c3e0d4e07bca1c73f7ae5631d574f12bbeb381ae2648edc"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lychee-bin")
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output(bin/"lychee #{testpath}/test.md")
    assert_match "🔍 1 Total ✅ 0 OK 🚫 0 Errors 💤 1 Excluded", output
  end
end
