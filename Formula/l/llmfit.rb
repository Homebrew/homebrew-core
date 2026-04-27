class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.16.crate"
  sha256 "e5b6480e3140522807e821f86c6e70d4358dc622f1feccbd6f9d3ec8542cb795"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e18b458132cb6e87fb4b5ef13700bc011d8cf53f57184e820c8e62193e986816"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "585e3502bb00a7fff2af96e810aa05b30f257c791f38ca7dedbcfc5057b1c862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b505ce9e9e7f48a34203dd52d4e37dd045985b9ff7451cd97af997764163bfea"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b7457f5a66573e1ec941a7fa4c51d5e6d44f91111ecb35288c112e9245f62c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3935240782ccce57ee81a7afd63e4b76b4ecbc25a2eada2dc56d231bb2bb9246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "789042f4de122a615e012d8838b415e693378aae89eaef52578e89ca53bdb7cc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end
