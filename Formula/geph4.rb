class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.4.0.tar.gz"
  sha256 "e05878fd3e7218b6d6c330fe7d52a7ec7fa952c20d74d90ee41260a439317c02"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1741483410bb389ccaf0c2a9f630f131086954f9172b27f36324f4ee6c44cc77"
    sha256 cellar: :any_skip_relocation, big_sur:       "a43e372d5a26b4e9af72ead11f1c179e447f1f5f4702109e90880115d1440e1a"
    sha256 cellar: :any_skip_relocation, catalina:      "bbb9a35300a1e134d0c02b16c0a5857222018ccf27a1c9e061fc696171580748"
    sha256 cellar: :any_skip_relocation, mojave:        "135ac866f2b36fe51796332581ea62f723507988a95c679d838baad439110f24"
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
