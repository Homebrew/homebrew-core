class ChatgptCli < Formula
  desc "CLI for interacting with the OpenAI ChatGPT API"
  homepage "https://github.com/kardolus/chatgpt-cli"
  url "https://github.com/kardolus/chatgpt-cli/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "158620e871411053310c6882a3e164e013389b0b6d99dd6fb42d8d82c988e51d"
  license "MIT"

  depends_on "go" => :build

  def install
    git_commit = "422f3b9dc0b290ed7b7bc86d1d6c83ff79266de0"

    ldflags = %W[
      -s -w
      -X main.GitCommit=#{git_commit}
      -X main.GitVersion=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "), output: bin/"chatgpt"), "./cmd/chatgpt"
    generate_completions_from_executable(bin/"chatgpt", "--set-completions", base_name: "chatgpt")
  end

  test do
    config_output = shell_output("#{bin}/chatgpt --config")
    config_keys = %w[
      name api_key model max_tokens context_window role temperature
      top_p frequency_penalty presence_penalty thread omit_history
      url completions_path models_path auth_header auth_token_prefix
    ]
    config_keys.each do |key|
      assert_match key, config_output
    end
  end
end
