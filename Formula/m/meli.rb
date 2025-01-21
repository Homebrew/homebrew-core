class Meli < Formula
  desc "Terminal e-mail client and e-mail client library"
  homepage "https://meli-email.org/"
  url "https://git.meli-email.org/meli/meli/archive/v0.8.10.tar.gz"
  sha256 "83573e8f2e8770831e35879c84297e9b353ba251d9a55960615eb1e32b9a1901"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://git.meli-email.org/meli/meli.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fdb0e4503db2d806000a92f8ee4744caa71d8535f9a19551c305dfaf2c9c50b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "406b311dace715934695e38f215d77bb44257b76c17a2d85942514f0149fc872"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4cb979565e6613629d73eb5d95566d7fdb0ebfcd5dc6b6df06d5b9e88574e3bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c67e8d72899564c60d5d33ad34e4001200682711ff5341e3860ac04b17c06d9"
    sha256 cellar: :any_skip_relocation, ventura:       "19400aeadea6aada5b91035393b61d3223fbb3001ff8b2863fdddfb7815526f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d63a56252e40706e8e15d9e2c543202ef6789dcb4fbd835c8f3acba2eeefb8a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "meli")

    man1.install "meli/docs/meli.1"
    man5.install Dir["meli/docs/*.5"]
    man7.install "meli/docs/meli.7"
  end

  test do
    output = shell_output("#{bin}/meli print-config-path")
    assert_match (testpath/".config/meli/config.toml").to_s, output

    assert_match version.to_s, shell_output("#{bin}/meli --version")
  end
end
