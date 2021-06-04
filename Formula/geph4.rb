class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.4.4.tar.gz"
  sha256 "c76f016677c5c2bfbd04a63025f8cc37e6c34de78434ed1d961902c3281074ab"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "754ac19ff0db94cd5d7f81a342d5bdd19a790b15b1aaa6fca4378fe5a87a0b40"
    sha256 cellar: :any_skip_relocation, big_sur:       "52c19f8c8bf1e26276c68282065d82f8d27478abdca19918929aba31214a91af"
    sha256 cellar: :any_skip_relocation, catalina:      "ed9769d14c3f8783645f824a86c5721ce5294a50384b85ce3b11f70525f970ba"
    sha256 cellar: :any_skip_relocation, mojave:        "c96841688274953e42cd83c17cc2f7f92e24a1aa261d381256a22df67c6e3702"
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
