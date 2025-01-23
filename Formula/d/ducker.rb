class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://github.com/robertpsoane/ducker/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "86f4a8aa3c1f50cd92a0203c6d71bbc07dcf7db5cf7798f3396a34404cda0d93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3af1d18af65f740713421aa230e4eb191ed67ab511d6ab4d152549536dba7f89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9389ad2835f4f929c00dedbadafe93a1c9f94a7e9188fef336fac4fe8c1d7466"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1bdc24f5072e07d36180a5340a7a062c947b81ab37074c8ec7374747ecf937e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ba9413e6e8d1309115db3ad01afc5d71dab595f831bb001358714e77499cf87"
    sha256 cellar: :any_skip_relocation, ventura:       "a8cc46a86928f70349fd891794f115c808d8f483b09a0f328dc3afec3120583a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84679a1cbf9f9ce9554521f11b3851b3c322b9b75c8861d45a7e6ada164b494b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/ducker --export-default-config 2>&1", 1)
    assert_match "failed to create docker connection", output

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end
