class Meli < Formula
  desc "Terminal e-mail client and e-mail client library"
  homepage "https://meli-email.org/"
  url "https://git.meli-email.org/meli/meli/archive/v0.8.12.tar.gz"
  sha256 "6f03f50b7e3ee29d34716f31d77e75eca72ab651d67ea1de2dffc5813565180f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://git.meli-email.org/meli/meli.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4df6b386819ad120f3a769b825ed9ce061ba27075a75b103039f3f7eede3bccb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ae5ed00801662f9da4b1a479344585e6d0480cee748dcacdb883b7ea2bb66e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dac2ad7eb3a1e48bda3441a6c9e0c2f63bf2c0d1ea126e88fb75de3d56d31eca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "393461b613aac77018e34a3fa8f61a5fabb3e8d8cc9d3c05e2ab8e6a5d98e8fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e12530beb8d7459163493fa1023db9e935166f2da8462c12d4045cd70634ccef"
    sha256 cellar: :any_skip_relocation, ventura:       "f9990332e7df125ca426b2365e96e29f58abf8ddef887e0ebf124e22b0683f18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10c9adf5564a3dc95ce9739b6b39d6fbba9ea4f41f79378fa26446223505e0d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56eff4ef3a14f017e0754562442c901e980c8b7ab10d2be634148dfe36cc9ec6"
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
