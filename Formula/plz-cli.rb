class PlzCli < Formula
  desc "Copilot for your terminal"
  homepage "https://github.com/m1guelpf/plz-cli"
  url "https://github.com/m1guelpf/plz-cli/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "84a8835f091b305d21f52c36a19b4f4264ee72348f576ea2dd5a4c383f84acce"
  license "MIT"
  head "https://github.com/m1guelpf/plz-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b759c8bd3faecb16a8255d4cb579ab31889d6a65dd9cddff8870362e3befb83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e445e675441a360cdd0cac091975920d7c933a00952d25ffacf975ecd6032cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "524a9879589ba979fcbeb074419a9924d969287acfff3cf5295638db690a1375"
    sha256 cellar: :any_skip_relocation, ventura:        "66b64a8fe94c38f8faa25f0ef8057a737a86979efe91f9d53a6bde6403d50eb5"
    sha256 cellar: :any_skip_relocation, monterey:       "de1b6da32b7ba0f9798ee454eea129b26cb2c86240f24d53cff25766eaa65f92"
    sha256 cellar: :any_skip_relocation, big_sur:        "94599fd498263edc0cf61c72ab4f88980e2961a6d5c9fac7a54910e077e868a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cda5b1b67611359fdca995c6a2fb68a3dde49ae6aa02bb0cc91b69f48eb7d48c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["OPENAI_API_KEY"] = "sk-XXXXXXXX"
    expected = "Incorrect API key provided: sk-XXXXXXXX"
    assert_match expected, shell_output("#{bin}/plz brewtest", 1)
  end
end
