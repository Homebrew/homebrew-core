class Halp < Formula
  desc "CLI tool to get help with CLI tools"
  homepage "https://halp.cli.rs/"
  url "https://github.com/orhun/halp/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "de4e931aebd420e800007c446115f9fa3e2e581cbb4f2db9cb10488862e5f98b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/orhun/halp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e355185848abc6b530cde818d30f01f6d4aebc6340000867cf3260c4983dbd69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "90151c6762fc2f8f021d83dcdfd7791a1ec6eeb8f21326a99045bf430f6fd04f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5a811ad95cf4dd2fe8eaea97a1bd0878e8bd9d57317e82d0a2ebb9a01f8176d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46621463527a0130f38fe08aabec8736830f4409440dc9b8332ef9995797cfcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "122153f544cae19d3b4ae5aebfc18e09deaf87e793b06b859924ddaf5b16a482"
    sha256 cellar: :any_skip_relocation, sonoma:         "ded7efbdeb80254547423d1538af040d268252a597d326663caf9aa469ea48b6"
    sha256 cellar: :any_skip_relocation, ventura:        "7387bc748aaba59be28c6c0e220034e115097b7b7ea453c75c128bebb0982286"
    sha256 cellar: :any_skip_relocation, monterey:       "a604ca28c91bcc23f3ca2d30c185cca378440a5ddbc5c548285e898f0b1d863e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bf016a89b83b085ec2dfbec7654727141a413552afee4bd0cfecee15d0895217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "525dfbe3581d9fce47ecb99abf03269c9b36282498bb6d971844846c66e01bf3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Setup OUT_DIR for completion and manpage generations
    ENV["OUT_DIR"] = buildpath

    system bin/"halp-completions"
    bash_completion.install "halp.bash" => "halp"
    fish_completion.install "halp.fish"
    zsh_completion.install "_halp"

    system bin/"halp-mangen"
    man1.install "halp.1"

    # Remove binaries used for building completions and manpage
    rm([bin/"halp-completions", bin/"halp-mangen", bin/"halp-test"])
  end

  test do
    output = shell_output("#{bin}/halp halp")
    assert_match <<~EOS, output
      (\u00B0\u30ED\u00B0)  checking 'halp -v'
      (\u00D7\uFE4F\u00D7)      fail '-v' argument not found.
      (\u00B0\u30ED\u00B0)  checking 'halp -V'
      \\(^\u30EE^)/ success '-V' argument found!
    EOS

    assert_match version.to_s, shell_output("#{bin}/halp --version")
  end
end
