class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.30.0.tar.gz"
  sha256 "e8248c2f4a3ed8e9a7386dc0ad953f6245166c3939b1bc1be5a8aa42eaa0132e"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e703a8263472bf0e229dd8931987358fdd9ca15799db92e8c9dcee14ed172cab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7414c1e6b2f52a900c4f0addb143285cad7a84ff57c21aaf128fe94e72832211"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "153cd3cca19951b30be0b91ddc15c698c45abc0f4f92e1abe1c6d1d7da7758d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0c96886f777c489be72519429942e9d3f097f265deecf3c487571eb40f4cbec"
    sha256 cellar: :any_skip_relocation, ventura:       "7755fdc7ecf936c0d533b9ef98b2f205e0eda2a083aa21b390c5429d67c901f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e978974c722a35885efb1141911ebaab0b84e8a35fbe44e399da3e3b3e6e2854"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
    generate_completions_from_executable(bin/"sg", "completions", base_name: "sg")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
