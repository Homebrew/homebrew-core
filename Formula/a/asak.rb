class Asak < Formula
  desc "Cross-platform audio recording/playback CLI tool with TUI"
  homepage "https://github.com/chaosprint/asak"
  url "https://github.com/chaosprint/asak/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "da90a31924a6ac7ed06fa54d5060290535afdfe1a6fc3e69ad1ed5bc82757e92"
  license "MIT"
  head "https://github.com/chaosprint/asak.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0eacdb4a479c653f777726c669eec0fc89c2a922c13b15bbfd8370c3b24417fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc34ad17c5c94e3a205d72d5cd89d632e9e77478b863c704711d57813174458c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22662e9e6284f51656b1e9b2ff845d1020891ad01f8ff39085f23f2b94063710"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ecbcbea3ea060f02617de9c3d5a80477e014b2b789c7330bf95e31ce70d5365"
    sha256 cellar: :any_skip_relocation, sonoma:        "971aa9cc9f4caad9bea64347102ffa2ac2ebc89de06aa6e1b1fc7c486fd21ac4"
    sha256 cellar: :any_skip_relocation, ventura:       "ac44eeb109efb1b9ce9e787e24e1c9ee917c8a0b889f2dff2576717644f6531f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df0d9919f8e49aea1800986f43644c84e3b0000b04de81ba7e2aeae1072320b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47670f65f8c158c2a27772c5ad9de162b9f11234c5b5bf110a87f3434d14bb78"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "jack"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "target/completions/asak.bash" => "asak"
    fish_completion.install "target/completions/asak.fish"
    zsh_completion.install "target/completions/_asak" => "_asak"
    man1.install "target/man/asak.1"
  end

  test do
    output = shell_output("#{bin}/asak play")
    assert_match "No wav files found in current directory", output

    assert_match version.to_s, shell_output("#{bin}/asak --version")
  end
end
