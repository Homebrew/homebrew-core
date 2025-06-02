class Mods < Formula
  desc "AI on the command-line"
  homepage "https://github.com/charmbracelet/mods"
  url "https://github.com/charmbracelet/mods/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "44e15c13d70d74369467df4d18b0a5ad9d977b344e76a39898002a04712271ca"
  license "MIT"
  head "https://github.com/charmbracelet/mods.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef4507075257b543ce0352b27723e0b70310221b5af17ee5ad2e45e660d39fb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef4507075257b543ce0352b27723e0b70310221b5af17ee5ad2e45e660d39fb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef4507075257b543ce0352b27723e0b70310221b5af17ee5ad2e45e660d39fb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f172da97622950b4d688514b07d9bd7711b4e935bb77602bf642f96525ca8db"
    sha256 cellar: :any_skip_relocation, ventura:       "6f172da97622950b4d688514b07d9bd7711b4e935bb77602bf642f96525ca8db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f7ce569623766cf59c6ab7df40eb76dd857055683aa1ad75dafc7b3482f0a92"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.CommitDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mods", "completion")
  end

  test do
    ENV["OPENAI_API_KEY"] = "faketest"

    output = pipe_output(bin/"mods 2>&1", "Hello, Homebrew!", 1)
    assert_match "ERROR  Invalid openai API key", output

    assert_match version.to_s, shell_output(bin/"mods --version")
  end
end
