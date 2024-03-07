class Mods < Formula
  desc "AI on the command-line"
  homepage "https://github.com/charmbracelet/mods"
  url "https://github.com/charmbracelet/mods/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "8116b04fd32879bf457e2c162b4e26418ec7a84556260bedf3ba4618ca19931f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47ab5239085e63789a87cfdc27e6f3a4a1c0e3e46557e4a42955fb133a1ebcc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "531c26b5f973c13ec7c3ab5cab0428cd1169950bcea93f045e089271273567cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9fb3afee33d6b5d0bb83ada59b2fa0a29aa4136fe45a54df15ea45a56127a69"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2a3b572b7f1b8e12adb30ea631184644b9b5dc7386b1be0587d3335b110d49e"
    sha256 cellar: :any_skip_relocation, ventura:        "bfff64a814e4833f348720a7389279ed96918ab2eaa8616beaf5c01ff65b47df"
    sha256 cellar: :any_skip_relocation, monterey:       "fed03bc88ed70f39db9ec87d8168737f3b68ccf0b35683d02d0713b1b7893253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d16e076f97fd17b8fa4a470132a1536d1a854ec7fe8d5b721bb8c03d99e235f8"
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
    assert_match "Invalid OpenAI API key", output

    assert_match version.to_s, shell_output(bin/"mods --version")
  end
end
