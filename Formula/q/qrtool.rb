class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https://sorairolake.github.io/qrtool/book/index.html"
  url "https://github.com/sorairolake/qrtool/archive/refs/tags/v0.11.8.tar.gz"
  sha256 "873e9324720bc0d526ca233db31c952902294f72a3b5265bef8333605e31f75c"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https://github.com/sorairolake/qrtool.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08b0026d4a4cb631fabd4351b7b34c73d428018612a327ae779aa721e87fbb29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84e50a973f4585383daf8beba9fda0abba46569411793fc9ee93de0d62bd6318"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b7f4c46fd57d27652f71226670c8350049786933b0126bd3143e5a54f617fda"
    sha256 cellar: :any_skip_relocation, sonoma:        "7647d101c521fe0871327f9f649c081ba1ea27e46405700e7755384ce95109e1"
    sha256 cellar: :any_skip_relocation, ventura:       "a21295fe7c80dc30731fa070318aba7ccf4e73569fa9b56c64e5663b2858b27b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1500f4cd68e7911d71c4398bdb33bcef404218641114d8c9869475cc22d462de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94e5bca91d85d01544e33d003422eb0cf6b20d9dae01405c88ed9dca13432fda"
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
    assert_path_exists testpath/"output.png"
    assert_equal "QR code", shell_output("#{bin}/qrtool decode output.png")
  end
end
