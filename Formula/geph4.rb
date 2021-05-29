class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.4.4.tar.gz"
  sha256 "c76f016677c5c2bfbd04a63025f8cc37e6c34de78434ed1d961902c3281074ab"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e30d897151ef49f6b3534258a860a17f0c709627b1edbb8f6f6224dda521021a"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3d6fa35643b18acb05924af78a5fb4d25e07366ef5443c83aef8871dbf1afbd"
    sha256 cellar: :any_skip_relocation, catalina:      "157f30802269827339b068ecc8c7c376b3e527629bd7c1436a5b6ca14b844cf6"
    sha256 cellar: :any_skip_relocation, mojave:        "4b9a675498f96fa52a89bfbc4259824170cd52c0b8d8c69393b19d722ecbf6b2"
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
