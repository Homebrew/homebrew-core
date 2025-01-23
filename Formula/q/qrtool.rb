class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https://sorairolake.github.io/qrtool/book/index.html"
  url "https://github.com/sorairolake/qrtool/archive/refs/tags/v0.11.7.tar.gz"
  sha256 "9b7ae7d54574773eaca98205e0ca5eaed200879a128818c83794b659e8139d79"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https://github.com/sorairolake/qrtool.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a784137d91945a91d151baec79662538a3957affc7cc89f48f42d2b8965d68af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaf691da974f807b5a2410cbf21ea477c22c877fcff94bf2c7b4705a5d4032c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30b7926abc4cf5140a3a7555b7451b3da7de2a432e4fc489538d36c505cb8ac5"
    sha256 cellar: :any_skip_relocation, sonoma:        "79b6996e14bd8c2418a2e0cb4931a73a8e45a4f5014d6fdbbb965d2572d4c767"
    sha256 cellar: :any_skip_relocation, ventura:       "d831501b61ec19b8f135e608498cbfe62b29620c0d530d1abb5291c6a55dc7ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fdd6b06407cca35698891e2b27d72124fd8c4190480355865b7798bf23bbe8c"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"qrtool", "--generate-completion")

    outdir = Dir["target/release/build/qrtool-*/out"].first
    man1.install Dir["#{outdir}/*.1"]
  end

  test do
    (testpath/"output.png").write shell_output("#{bin}/qrtool encode 'QR code'")
    assert_predicate testpath/"output.png", :exist?
    assert_equal "QR code", shell_output("#{bin}/qrtool decode output.png")
  end
end
