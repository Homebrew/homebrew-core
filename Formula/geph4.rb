class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.4.1.tar.gz"
  sha256 "c9213b919468378414cb88393cd51e3d432dc58f4cb79e9943d7cec9cc52de2c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8873855fd73357ffec65de348b42a3d615bfa2e4e25ed74cdce1ab82995d7cb1"
    sha256 cellar: :any_skip_relocation, big_sur:       "b184b00aaf36882bdf57b07a660f9cba08d8fa8f47a57456e56af7bdf59f2091"
    sha256 cellar: :any_skip_relocation, catalina:      "b16cb448b221ddd3d11ae8b064fa0da1c7c4e606bc3e2d1e728284e9704b13e7"
    sha256 cellar: :any_skip_relocation, mojave:        "2e36010649cef8637720934939d0488cbd9a13533c2d93b880e11972d0614601"
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
