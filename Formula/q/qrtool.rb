class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https://sorairolake.github.io/qrtool/book/index.html"
  url "https://github.com/sorairolake/qrtool/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "ec6d240667a06a191188a44037b7173811d736c086c607d82d6d9b374c9332d8"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https://github.com/sorairolake/qrtool.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7fd728f1573a70e95e09560370b8188f45d896e5ef439301ef38de09d7433ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f04b0dac70a55a97a3db5c72a2420b4530d32bf11ad40d292907cfcb28ca845"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "393435db0ebf40b60920491dd73ad77d4bcba0fa7ca7b4c7a7cbaf4aa9b5e3c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba912853beeb9214c17ff69a605071536daee4e2e425d9578ff54a78f2ff3539"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3551d3a7a17ee685e7995b64c67270801e840cbd760b4c930c3e2f3c569f52dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b41c6e2c7a2d319fac15406acb1e50f4262e53620966bdc631215ce786ac464"
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
