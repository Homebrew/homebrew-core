class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.4.20.tar.gz"
  sha256 "90b778edc01dd3de6bee073b22b5c2151c326b6fdf921fbf7d7af6633ea1f75a"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0036366831b1bef03d3db6bb5d9903e5b83159a42dd586a1f56e7b661ffb4d06"
    sha256 cellar: :any_skip_relocation, big_sur:       "defea698cf2fc65da4c2c99d6a55087e3f9ca5bfb1b6f2fc22d17d2e7f6a3d36"
    sha256 cellar: :any_skip_relocation, catalina:      "08758f514b8f22ebae583102bc137af5453e99ca3e2d236f72c2ab58f094868a"
    sha256 cellar: :any_skip_relocation, mojave:        "c27c3e1190eaf89bbd1112fc0c0cdb863ca99a9ac902dbb5759e216300ca06fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b1d097fb361fbc9700a78e23749a86ba089ea3f61ba3c3a354bf7ea9d5c64d7"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "{\"error\":\"wrong password\"}",
     shell_output("#{bin}/geph4-client sync --username 'test' --password 'test' --credential-cache ~/test.db")
       .lines.last.strip
  end
end
