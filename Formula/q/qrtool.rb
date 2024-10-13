class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https://gitlab.com/sorairolake/qrtool"
  url "https://gitlab.com/sorairolake/qrtool/-/archive/v0.11.5/qrtool-v0.11.5.tar.bz2"
  sha256 "f43d056aa479c87642df64a5f0a4b64fd7b973c895603c64a0a39da35123c9de"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https://gitlab.com/sorairolake/qrtool.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38cb29e920d4e029896acbd17f6e89c7041190ee2a1eeeca6f6b47f3fc05e2ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ded7cb5c9cd7cd080b1b80ab01c0b2837c85930ec4dc4112a016bea1c35bb33f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43b90f434f185413aefe32015c587c50ebf4315d2d3a1ff0828ba96d9843c309"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4353dcef04765a452301ac71545044e43cc46e10ee09612826c602c970c3a56"
    sha256 cellar: :any_skip_relocation, ventura:       "dfab0b6cba006afbe8fbc4a5295244200d9aec408e016698cf1b1c82f7c9c431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6976374a2a8219ddbb8a81dc11354b3c8d42f732fe20a13dcc25f67e5921a59d"
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
