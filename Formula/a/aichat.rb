class Aichat < Formula
  desc "All-in-one AI-Powered CLI Chat & Copilot"
  homepage "https://github.com/sigoden/aichat"
  url "https://github.com/sigoden/aichat/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "eb97284be786b2b625992ab875bb95da2aa3707c063cb0c34521cb01024b38cd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sigoden/aichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0be57fc151a7bcb38ec847a18caa6e69f264931998d95393f48f3ace157df044"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd0302baafa9555935be800f1cb34933af53ae133b7faff57c0bc05e2c9e6907"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "274464d65392a173e0ebde8301809d933117d5af2b2babcb819c24b9e8c66afa"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1fe4c06df47fb1053d5aa2461ff7beaa7354729d692581f586d8844dae64876"
    sha256 cellar: :any_skip_relocation, ventura:       "3b1169ed0dec2a03a40c33642f1b633784b48a1b354abe31ac41d2e2576886ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c48b49add1ce94a0ec41bc628e00039b48cb78e07f51f7abdf558c0713bfd8ff"
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
