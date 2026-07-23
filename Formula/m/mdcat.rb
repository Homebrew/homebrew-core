class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.13.0.tar.gz"
  sha256 "8dfb329df37ac630642e0e8adf6e2b59dd09a95b417b7a6e5b627aa16ed04200"
  license "MPL-2.0"
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dea0314c570d1cb948c5e6a395cc4f57b89e61c99d5afd2ddb101974d15dd817"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c535703e21f49e65af3a28acba138bca36b0c7733eaca1d9724ef7e39e0656f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae81c2bb51853b995d75712092ede3db09c4e214b331b6e097c48f0136721096"
    sha256 cellar: :any_skip_relocation, sonoma:        "6684c728b0e3e7a633ec981a66fab23aba1e5bc6462530657dc60df799fc937c"
    sha256 cellar: :any,                 arm64_linux:   "50f33f4e50bb854c0de72d9b2597d0147af9ebc16e1d16697b0ebca78fa2e597"
    sha256 cellar: :any,                 x86_64_linux:  "43ff22d8fef0138e96185a1c59048454530aaf482ecf7e90dc0c01ba8d1b35a7"
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
