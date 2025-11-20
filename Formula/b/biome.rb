class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.3.6.tar.gz"
  sha256 "0ba5afb0076bb267d2e734e158a613363b8eb238406fd8032444e549bcc1ea65"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "190b906428432dc71a4f2a25f30bd87a4aa9726516c3c2fa355ae1b0d0f1320f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "708619c81e068b73b6ea43ad2d92474562fd71cde56f64513a142c2cbf1a9dbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e2b6f9fdf30dabd032708e242a02ab4bef75f6d9292da5e6b77d6c2f9b9e332"
    sha256 cellar: :any_skip_relocation, sonoma:        "20d282cfef611e8b24b146d75aba35297b0b69f5ab8c46680cf046745bf6682c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b9656c800479eb0ea07fb7122b482d898b733600071d94177dfaed8642b4bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e937fbff6f78c6a882bd99567b948097d8823d5165f8d004049b74126afb0ee0"
  end

  depends_on "rust" => :build

  def install
    ENV["BIOME_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/biome_cli")
  end

  test do
    (testpath/"test.js").write("const x = 1")
    system bin/"biome", "format", "--semicolons=always", "--write", testpath/"test.js"
    assert_match "const x = 1;", (testpath/"test.js").read

    assert_match version.to_s, shell_output("#{bin}/biome --version")
  end
end
