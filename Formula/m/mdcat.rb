class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.17.0.tar.gz"
  sha256 "91e17168d1059f5524e50442e6623c3e645994c9b09c46867119f142e3f3c465"
  license "MPL-2.0"
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e4e7949ce84a385ff81f9d2623049542a8ead5b05e82bbc60181b6c79d18d0a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5ec1de76c69e5989730fdcd8f3e794d4711ae59de4027fdb67cf1ee4b51cfd42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08c060f40f354d40b5d96d19fd8d4458bf8c05ba62e0d20b389ceaa001234961"
    sha256 cellar: :any,                 arm64_linux:       "dd385e342954e6454915b49b8df778b62689460b7bfde534baecbad02a904afc"
    sha256 cellar: :any,                 x86_64_linux:      "c92642c3909cb175e7d8de074d0a309841ccec00fcdb202b86dd6802612bb82d"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    # https://github.com/BIRSAx2/mdcat?tab=readme-ov-file#packaging
    generate_completions_from_executable(bin/"mdcat", "--completions")
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
