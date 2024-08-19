class Aichat < Formula
  desc "All-in-one AI-Powered CLI Chat & Copilot"
  homepage "https://github.com/sigoden/aichat"
  url "https://github.com/sigoden/aichat/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "e7ef65102b346504bfa60a9db5b49cec981f4c99f40c3ebfa88a7e1dad947fa1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sigoden/aichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34ca321801a7864eb987da48af0c16dd7433c7414da8daf52316a9827a906736"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "157b7cc0ce360620919d3d3926d726f60649510c8a189b6bf523760d647d71b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "783ce942096b579814170237174d79527b3264fece2fa8fc18ad2a6eb40100b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "c072ce14e6402af27631bc725025091cb8c60692d4eb36745407a96ce7ec65fa"
    sha256 cellar: :any_skip_relocation, ventura:        "003523924973f3ee6528fe5792f90fc3774d40d65263e019212be03a3c877b26"
    sha256 cellar: :any_skip_relocation, monterey:       "eaf4c2a0bfed527055ac200f360344673b2ceba66937f5ba0381db958fd5a814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cea885816c86544edde84174f62444a0f57a1a9cb071d73e2d435f790feaa4f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "scripts/completions/aichat.bash" => "aichat"
    fish_completion.install "scripts/completions/aichat.fish"
    zsh_completion.install "scripts/completions/aichat.zsh" => "_aichat"
  end

  test do
    ENV["AICHAT_PLATFORM"] = "openai"
    ENV["OPENAI_API_KEY"] = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    output = shell_output("#{bin}/aichat --dry-run math 3.2x4.8")
    assert_match "math 3.2x4.8", output
  end
end
