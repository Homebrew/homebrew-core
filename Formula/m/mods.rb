class Mods < Formula
  desc "AI on the command-line"
  homepage "https://github.com/charmbracelet/mods"
  url "https://github.com/charmbracelet/mods/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "885388ac0e55ecec92648b721baf5d392e33f146cf5b92f9f23f365d9746cc07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "29b3fa4adbd7ff68bf2cbb4389b32d5c72bdddd8813b675b1685a935669fdcee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29b3fa4adbd7ff68bf2cbb4389b32d5c72bdddd8813b675b1685a935669fdcee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29b3fa4adbd7ff68bf2cbb4389b32d5c72bdddd8813b675b1685a935669fdcee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29b3fa4adbd7ff68bf2cbb4389b32d5c72bdddd8813b675b1685a935669fdcee"
    sha256 cellar: :any_skip_relocation, sonoma:         "6398c20e5b5db7b6470349b46af260956f0931ce86a639891c414fb091cee0b2"
    sha256 cellar: :any_skip_relocation, ventura:        "6398c20e5b5db7b6470349b46af260956f0931ce86a639891c414fb091cee0b2"
    sha256 cellar: :any_skip_relocation, monterey:       "6398c20e5b5db7b6470349b46af260956f0931ce86a639891c414fb091cee0b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54cf1956b9d32d996c51b904839ba5fc81849d9c735cba1332c14d168c64946d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.CommitSHA=#{tap.user}
      -X main.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["OPENAI_API_KEY"] = "faketest"

    output = pipe_output(bin/"mods 2>&1", "Hello, Homebrew!", 1)
    assert_match "ERROR  Invalid openai API key", output

    assert_match version.to_s, shell_output(bin/"mods --version")
  end
end
