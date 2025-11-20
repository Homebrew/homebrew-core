class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https://sorairolake.github.io/qrtool/book/index.html"
  url "https://github.com/sorairolake/qrtool/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "3271127e2be7ef3e51cd22648b5f6168e1da00d19cd4b35c1b752029be08d41a"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https://github.com/sorairolake/qrtool.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae622c06212700aca23dc02eb547ad048d725ce0362abb75ed7f05c8006d62e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c96a940b830ad2e0ac5f8ff3170d8c94596c521a67383337a42c0a4e5567bc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "249ed7ff901645e8a7c9b6ff7ff260e2bacb7f0056a738f498fe3f19123ebe01"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2da0b6b354049c0d4a11e0ee10735e8ca8e352f2a0e1523a1303598c2e8a83d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d1ce21be8979eb1680030361a86a40353ff9c106231f9bb506c68d7d5e6c7cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66167709896dbc309226f03f81d8db56b29b259aad013c520b0569bbd38be7bb"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"qrtool", "completion", shells: [:bash, :zsh, :fish, :pwsh])

    system "asciidoctor", "-b", "manpage", "docs/man/man1/*.1.adoc"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    (testpath/"output.png").write shell_output("#{bin}/qrtool encode 'QR code'")
    assert_path_exists testpath/"output.png"
    assert_equal "QR code", shell_output("#{bin}/qrtool decode output.png")
  end
end
