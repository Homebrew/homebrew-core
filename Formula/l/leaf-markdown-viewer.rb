class LeafMarkdownViewer < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://github.com/RivoLink/leaf/archive/refs/tags/1.28.2.tar.gz"
  sha256 "838826fe69d90888b9a1e4d62e98565f2ab784054b13e64adba313d21a3df86b"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a7bb9d85a3b838b584f9e5de2fa1d9628e78a4ff5afe0bf9e1166fe1ce670564"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2bd2ddfae6b83c3a74f704b3be9105bc7fd5642c0619dfe94b537539244e0dcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f377e1604c2d06b95b6652482bec935370e742db2b233282067c17da6a204958"
    sha256 cellar: :any,                 arm64_linux:       "883e908e51fb176916721e97b69d300e20b112c9c9012f035f31fd63bb05dbae"
    sha256 cellar: :any,                 x86_64_linux:      "48b25215b339df320516f1c5b98bbf8ae6abf7ef1c6e121c1caf6e9b139786aa"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end
