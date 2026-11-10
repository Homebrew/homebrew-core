class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.20.0.tar.gz"
  sha256 "3436d183cf55d628245b30e605f14a4d7b3b129a457e34eac029828e2c2a07e6"
  license "MPL-2.0"
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2cd3eeac82c6359c3ad92f756f6be9abaefecbff2ebb6eeb9fa9169b470b121e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0daeeaed233f440acab7f02e668e1fe7fc6c718eeb4645567ee0f97d13fec2af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "adb5c284979b50443b6db96c1dfab84f1d2ab554e7529352823d9b69b04cef98"
    sha256 cellar: :any,                 arm64_linux:       "f4d16ab10e5c3d39c3d3de8571018fcad6748648c508b7d61dd15b0fb86eddb5"
    sha256 cellar: :any,                 x86_64_linux:      "dda538de6b6fcb22f9bf5ebc9bceca6dacc4160b6c055e9bb3c9a90276043344"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    # https://github.com/BIRSAx2/mdcat?tab=readme-ov-file#packaging
    generate_completions_from_executable(bin/"mdcat", shell_parameter_format: "--completions=")
    system "asciidoctor", "-b", "manpage", "-a", "reproducible", "-o", "mdcat.1", "mdcat.1.adoc"
    man1.install Utils::Gzip.compress("mdcat.1")
  end

  test do
    (testpath/"test.md").write <<~MARKDOWN
      _lorem_ **ipsum** dolor **sit** _amet_
    MARKDOWN
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
