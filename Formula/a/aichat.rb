class Aichat < Formula
  desc "All-in-one AI-Powered CLI Chat & Copilot"
  homepage "https://github.com/sigoden/aichat"
  url "https://github.com/sigoden/aichat/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "0b586419ce4e29e02eb165e0ab668e0661fac305840348467ab5f45e42551a5a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sigoden/aichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75ff892e2de7a3d752e65b088e483ebd3371fdf5e82c1302d1016206459bc0c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c760cf616b5c113ce306e7d19c6a39a12ed54dd4dcf03f41f57f9012bb1b3a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b593e7b7f291b81e3e7a1ba521aa48fcb9e313ef221f66253b4edddae6c07f15"
    sha256 cellar: :any_skip_relocation, sonoma:        "19aa8acf1e3bfdb7e730473d74ccfcbb4ae872fa1d91e8ee6456e66dc0d193f0"
    sha256 cellar: :any_skip_relocation, ventura:       "6f3f4043a3ba73665ed4a84a34bc6891bb7af630d21f8ab0dfe8de7900ce7324"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9ec159830d1c07c15a06e9b7e8e395b4bc9b1c797e6e578eee612ab18131290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45476f83ef63ae2df06366d5822de1746d285bc9d26b82e93841235ba959c3c0"
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
