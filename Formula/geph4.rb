class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.2.6.tar.gz"
  sha256 "771267c0f8e382940e6d4a5d3982b05d02e497c98f32a6759387dc39463ca2e0"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cf2e42812612e798f211f3cc9dabed0f37673fb34d6b5ac83f63a2a9507962fd"
    sha256 cellar: :any_skip_relocation, big_sur:       "a479a5b3bab0caf7adfe48334824436a11abdae3f21873c7ad99a8b8db2836a2"
    sha256 cellar: :any_skip_relocation, catalina:      "ebb7dfa3b2871009c0d3557a7dafedd4af5e90a32991c244579aa286fcc249a6"
    sha256 cellar: :any_skip_relocation, mojave:        "9ec34ef55f073554cb763365b4b71d42452c5673766efc82bcdec776a27e8dc6"
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
