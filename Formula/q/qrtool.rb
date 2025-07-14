class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https://sorairolake.github.io/qrtool/book/index.html"
  url "https://github.com/sorairolake/qrtool/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "351ba9fe32ccf4dfa51902443f8459c9f5efc645f0b40523cb9c10f38d5fd18a"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https://github.com/sorairolake/qrtool.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82956d722db6a1f6b0efe8ec76045a365fee2277aeff94375133e352bee9b58f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "697e091a5a9785522866749e91775a3956992eff891df6beb482661a704516ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3934b5147079c83ef5e413441fbcef0752dca293e1309bbe2239b9d9d6e91fd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfa93d82b700a78832dd99f66f0693bebded392c5770decdec2fb65f7cf08412"
    sha256 cellar: :any_skip_relocation, ventura:       "aff2237ae6e7326e64a961f54eb1fcac227cd9910ee1a51b093f3444e839d995"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b2f818af8df80187d72a1e2a71ac52978e92e3569c05da00d3424a478ae6788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08fc2bc681b6c453a75383e964864b3138c85a4978e839238d25400cb6e5d492"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"qrtool", "completion", shells: [:bash, :zsh, :fish, :pwsh])

    outdir = Dir["target/release/build/qrtool-*/out"].first
    man1.install Dir["#{outdir}/*.1"]
  end

  test do
    (testpath/"output.png").write shell_output("#{bin}/qrtool encode 'QR code'")
    assert_path_exists testpath/"output.png"
    assert_equal "QR code", shell_output("#{bin}/qrtool decode output.png")
  end
end
