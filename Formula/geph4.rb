class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.6.6.tar.gz"
  sha256 "a10582bdc20b72054877d65aa5a30d0702a63a6362f60edd4960c9be5dc3f7d3"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2359f070b36fff71553bd1b1434d600b9fb61187507ac516ef8941eed3a38c89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b47bc078c6d06ea71481991148fe05756a34d7f5e831bf8fd8296f014f8c3036"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2a4d9304721fbc5e33fef21690630a5359a8d41667c1fd90f0a4d8ee632b4f7"
    sha256 cellar: :any_skip_relocation, ventura:        "b1a39a17a173045f7e3c71b8a0c76b559fbdb8ed13057df9ee4bb4a5754501e3"
    sha256 cellar: :any_skip_relocation, monterey:       "1929be19dff08b9d265caa553ad86d629a64a7d47ea64e42d7b2a3db7d1191cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2d81df62b9298def302ad3454a7f25c53ac2c2c495932d3ed90c8f4b9382ae2"
    sha256 cellar: :any_skip_relocation, catalina:       "3f0953f038ef26d8d864e9fce426bbcf3a7ac7b27fb87db4cf191b59b0c7cec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a17bb8a2b3c0890cae0c68bb0ebb8b91cf84c63270e18950f09ee681e499d27"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid username or password",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
