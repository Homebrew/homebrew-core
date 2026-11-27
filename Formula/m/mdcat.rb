class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.20.2.tar.gz"
  sha256 "511a20572635faa0d6b0fd1080d7336a5b38738ad6d189abe9c7a71facd3c5d7"
  license "MPL-2.0"
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    manifest_sha256 "3373326ac4e0b4324b332631e31cf299076663f92dfb00688acd3a518c77cce4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a112cb9f542e29de3ce045e497d2ccc1c0d4957bd343c3a9957e6c4329ebc5cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da43a5b497c09a646637f13f93a39066d605a8c2649cdcf49b8969d761f5fdba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b2cdc9e3f468dc71b8d827c240baad85a84582c5215a966407002b1da272e36"
    sha256 cellar: :any,                 arm64_linux:       "f80bc6cadf8d5c3465da53f11390fe8f49fc42f2bd878fe4d560a2d26eb74547"
    sha256 cellar: :any,                 x86_64_linux:      "9f8867ce22f543fdd3eafb99685e5aa409a69a306bab0bad2570a6d44a7202c1"
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
