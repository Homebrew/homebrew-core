class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.19.0.tar.gz"
  sha256 "3be97adf9feff078d95e64f176c957074d20e1111046eb7d7331aefee2c65b9d"
  license "MPL-2.0"
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8ec48e3625ce7ef829e28c74f0c41fd4e120209c2b793574cb97ab93827d2c61"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1107532868a674eb74dc29c728a346a35f3f515cdda12e24f5f51a384b039ca3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d2bc088b350921156da726de602b7056556dff9e21e7a45f372923d7a75238c0"
    sha256 cellar: :any,                 arm64_linux:       "c785fbfb0a53dee7d428b762297fef09ff66fe2091fcff844a317fe061a3356d"
    sha256 cellar: :any,                 x86_64_linux:      "c9a4ef930ea3b9c721d357de6dd5faa37920cba1aa622f481e26718493291c51"
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
