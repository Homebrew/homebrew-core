class Doxx < Formula
  desc "Terminal document viewer for .docx files"
  homepage "https://github.com/bgreenwell/doxx"
  url "https://github.com/bgreenwell/doxx/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "6923cefa432a08adacedeb105902d47858f0ceea51b00e21e8b10117d86ca9e6"
  license "MIT"
  head "https://github.com/bgreenwell/doxx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49c27ddd59c8a5a6162a8e4fab2324a793f08b4dc2440674755367cb9c203efc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7202e48ac3a345aba665387d1fe9fc978bec4eadaf4c31bf5d945528a6571b7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83492cb4d56b769d7b9e177614d08d6213b9f9d447a6c05ff714c632b5e95489"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "325b30f5c19c455bb1ded3e7e64be7d219d11b0b1426069fe311eded0094c6c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fe8442a97b65427a9ecbbe074923a4ffcf062a2e83ecf0f270bfa26476e715b"
    sha256 cellar: :any_skip_relocation, ventura:       "a8a50cb92bc4f223e82bd58993e00524b4b5dc3b6e51a21b5eb9176741c70880"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "352b173888121c9e7e64fe475029471424b2a7fce258ff90161b733d76f79c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88ad21c8c661a8b9fb89b62cf64a9026d448a1a1c49e65b110bc6e209d4c1a0c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"generate_test_docs"
    assert_path_exists testpath/"tests/fixtures/minimal.docx"

    output = shell_output("#{bin}/doxx #{testpath}/tests/fixtures/minimal.docx")
    assert_match <<~EOS, output
      Document: minimal
      Pages: 1
      Words: 26
    EOS
  end
end
