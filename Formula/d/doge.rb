class Doge < Formula
  desc "Command-line DNS client"
  homepage "https://dog.ramfield.net/"
  url "https://github.com/Dj-Codeman/dog_community/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "21d459f1f88d6a1e001a747b84782f180c01de8f3c39f3a1389c352b2f2edc88"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71948198c956b00eb4a7876019460f9280593408830d4283419976b223699961"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1d4cd89b97ec72efb1c213373314bcf50c2f550f616dedb72be413a6b591746"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "468d651e833eedaf42d4f9b707c9cd6a885f0a138cc22527d7fec660d344a18c"
    sha256 cellar: :any_skip_relocation, sonoma:        "efce39ee93945f293a68d081a90865e4702ad02979d6c71a6dfa4e5baf0cabb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af6ca23e2bd46b2076cb90e8d5a36de27c701ced018d45ae062f6861d23a486f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e1a7aa1977d9189061c8d1b0a25f8117f3f1a5b4d920dd832fb49cc5461e62c"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/doge.bash" => "doge"
    zsh_completion.install "completions/doge.zsh" => "_doge"
    fish_completion.install "completions/doge.fish"

    args = %w[
      --standalone
      --from=markdown
      --to=man
    ]
    system "pandoc", *args, "man/doge.1.md", "-o", "doge.1"
    man1.install "doge.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doge --version")

    output = shell_output("#{bin}/doge dns.google A --seconds --color=never")
    assert_match(/^A\s+dns\.google\.\s+\d+\s+8\.8\.4\.4/, output)
    assert_match(/^A\s+dns\.google\.\s+\d+\s+8\.8\.8\.8/, output)
  end
end
