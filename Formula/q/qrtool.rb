class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https://sorairolake.github.io/qrtool/"
  url "https://github.com/sorairolake/qrtool/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "f783259f13388795b8894d8af661d0c5dea95ee0e7a38460174c56ad305ce7f3"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https://github.com/sorairolake/qrtool.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfd094f526c6a3e4f50c3cc1ade4dfe895a335edf4c8e64faeaedd2553357513"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb36c1f774e7f719196b47a4ffde8044a673079befa87a46d70a2f738a593d7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4e6cd6f9e05b8a5f22bcb96252e3950cd0da4e0fb11533c10509c199615d0a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "1dc28e8c37e8b3a7d471c5611673105aacde87530b2700897adecc659b07c7f8"
    sha256 cellar: :any_skip_relocation, ventura:        "d443394455e08dcc4da2ee8448cfe7c695222c9e28516a0b89289cd4880093b8"
    sha256 cellar: :any_skip_relocation, monterey:       "a4a4e34defa3ddab09aa1e46341e9758e6985cebe72f2cec2d4e8431c3759bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad068e15b4ab816b055de23d1710fcce54a71473511c74a45a46caa2a68f594a"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    outdir = Dir["target/release/build/qrtool-*/out"].first
    man1.install Dir["#{outdir}/*.1"]
  end

  test do
    (testpath/"output.png").write shell_output("#{bin}/qrtool encode 'QR code'")
    assert_predicate testpath/"output.png", :exist?
    assert_equal "QR code", shell_output("#{bin}/qrtool decode output.png")
  end
end
