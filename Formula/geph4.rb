class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.3.2.tar.gz"
  sha256 "641fd83b34ed4acbbde09df603e53a9b55f32ae9287899f877b7512f6662933f"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "331f8dcee2426bd53dc263d34bd45535555203970636806355f4b68d362b52b8"
    sha256 cellar: :any_skip_relocation, big_sur:       "8526e0d56cb7a662fd7c13b47836583aad0dc267653e330e28973a075ce7fba1"
    sha256 cellar: :any_skip_relocation, catalina:      "de673434aec48cb2961920aa013818b6a8e1d8866dc7d51462ce41f8402564c4"
    sha256 cellar: :any_skip_relocation, mojave:        "e9b28073a9179e7a799626fe39a7a66138f8019ef8622765c2bc4c1680934c91"
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
