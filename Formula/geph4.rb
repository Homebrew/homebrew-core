class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.4.2.tar.gz"
  sha256 "1294c45c642dcbc4e913549cdf12168ab5df504e83b2b9fd887e99c22609e7b7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "540f50cec4ba84adfdb667a38be3faf26f5eb290e834a5c7fe8a3d82b96612ae"
    sha256 cellar: :any_skip_relocation, big_sur:       "c85445268a639e9f519d9b7dca9fc58f67a2802ff8242008bf1dcb97af0ce2ad"
    sha256 cellar: :any_skip_relocation, catalina:      "13982c2d6a62cfa11e4dd97ac57b935340a62dc0997d26103a35fae83fd0f3a9"
    sha256 cellar: :any_skip_relocation, mojave:        "eac0932aa51e7638b82f1718f717716d573bc0dd5c15db1da8cd6ebe11015b2d"
  end

  depends_on "rust" => :build

  def install
    File.delete("Cross.toml")
    remove_dir(".cargo")
    Dir.chdir "geph4-client"
    system "cargo", "install", "--bin", "geph4-client", *std_cargo_args
  end

  test do
    assert_equal "{\"error\":\"wrong password\"}",
     shell_output("#{bin}/geph4-client sync --username 'test' --password 'test' --credential-cache ~/test.db")
       .lines.last.strip
  end
end
