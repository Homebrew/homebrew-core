class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.2.3.tar.gz"
  sha256 "1d6578a21df81bf4f7b061db5a76be41f1597ebc977974c24f9db59441f0cf46"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa0851516692ce33f78932db31250b4fe7434a794605673645639d9a07df93b4"
    sha256 cellar: :any_skip_relocation, big_sur:       "7c449365260ad7691ac855fcaf8fb723d142215024899176a80b82c5711e8884"
    sha256 cellar: :any_skip_relocation, catalina:      "2c551c85a85f897ef8421f30c5b412ad3d1e1b0592e4cdc8fb836276396d1d6c"
    sha256 cellar: :any_skip_relocation, mojave:        "e6054b0b5b9cd1e7ddb60b5ed72d381b6b015149ff4d0e526eab8362c1c0c877"
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
