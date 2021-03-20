class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.2.5.tar.gz"
  sha256 "75d53ac21f440fb1b9f8f5e9434fe90bf039c8295dcff05ae672c785bdc1fa45"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4ac9c4ac1ffc0dfd3e8e25d52425d8c114e67081ab4c9698f837c20e26cbbe40"
    sha256 cellar: :any_skip_relocation, big_sur:       "d101de8bfba4f1327fb48441bf2b5f7f9544c27a4cf61fb8f483cc05ad7c7a23"
    sha256 cellar: :any_skip_relocation, catalina:      "80aa6a2f0ad16a714feb4987826752bcd9b0e3f7498dceef845ddbe991d79096"
    sha256 cellar: :any_skip_relocation, mojave:        "48afa000ef2b2038ed81a80403ea74ea5bb54e753a63e3a4c762ffcd3ad02c1a"
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
