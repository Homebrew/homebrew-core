class AssemblyaiCli < Formula
  desc "Quick way to test AssemblyAI’s latest models right from your terminal"
  homepage "https://www.assemblyai.com/"
  url "https://github.com/AssemblyAI/assemblyai-cli.git",
      tag:      "v0.7",
      revision: "ce19d72b78ac6bbc14623371c81cf139f7707134"
  license "Apache-2.0"
  head "https://github.com/AssemblyAI/assemblyai-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
      -X github.com/AssemblyAI/assemblyai-cli/cmd.PH_TOKEN=phc_G3bBjrSrhrQ9OsVnLBFGi1OyMxZ7JjX8kkGYo5c2a85
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"assemblyai-cli", "completion")
  end

  test do
    output = shell_output("#{bin}/assemblyai-cli config 1234567890")
    expected = "Invalid token. Try again, and if the problem persists, contact support at support@assemblyai.com"
    assert_match expected, output

    output = shell_output("#{bin}/assemblyai-cli transcribe 1234567890")
    assert_match "You must login first. Run `assemblyai config <token>`\n", output

    output = shell_output("#{bin}/assemblyai-cli get 1234567890")
    assert_match "You must login first. Run `assemblyai config <token>`\n", output
  end
end
