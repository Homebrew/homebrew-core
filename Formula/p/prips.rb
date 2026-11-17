class Prips < Formula
  desc "Print the IP addresses in a given range"
  homepage "https://devel.ringlet.net/sysutils/prips/"
  url "https://devel.ringlet.net/files/sys/prips/prips-1.4.0.tar.xz"
  sha256 "f2278ccd3dd3656a4f3ed5bd983b04719c24880ab2b87972d972f005bc138943"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://devel.ringlet.net/sysutils/prips/download/"
    regex(/href=.*?prips[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "08a5e13fd5ab4ddce6dfd796bfdfc50acaea51f43802890ae5374ac0dca97a7f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b19866d974098095a35570b4a3e8a06b3ec69357477976f8b45c663e26eae2a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dbebfe53322629b304258a6f85b1a25a2ede9d2c6a351e5c2968db4f7fc2d055"
    sha256 cellar: :any,                 arm64_linux:       "8244d747552421e099b84bf07fdcc3fb4e22fe5b4a182b08ab4b42ed39a78055"
    sha256 cellar: :any,                 x86_64_linux:      "d4ed0c8c8fe129e19ef261acc7343de925bcd798a1f915691cf40092b4c8844b"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/prips")
    man1.install "prips.1"
  end

  test do
    assert_equal "127.0.0.0\n127.0.0.1",
      shell_output("#{bin}/prips 127.0.0.0/31").strip
  end
end
