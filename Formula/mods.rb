class Mods < Formula
  desc "GPT-4 on the command-line"
  homepage "https://github.com/charmbracelet/mods"
  url "https://github.com/charmbracelet/mods/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "553a405cd496b85fbcaa29aa2ad0c1170b55063f63903050eb886eb976e2b55e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0639fdbd9d75225ef3b4879efab74d3c3dbd3fedfd07bedc2931efae61fbc27d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0639fdbd9d75225ef3b4879efab74d3c3dbd3fedfd07bedc2931efae61fbc27d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0639fdbd9d75225ef3b4879efab74d3c3dbd3fedfd07bedc2931efae61fbc27d"
    sha256 cellar: :any_skip_relocation, ventura:        "4864ec2ea12f0cca35ccbc4d1b8080f9434e7ec9e4430e82def3629e5764baee"
    sha256 cellar: :any_skip_relocation, monterey:       "4864ec2ea12f0cca35ccbc4d1b8080f9434e7ec9e4430e82def3629e5764baee"
    sha256 cellar: :any_skip_relocation, big_sur:        "4864ec2ea12f0cca35ccbc4d1b8080f9434e7ec9e4430e82def3629e5764baee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54b74bc0ad2e733504c28a12451e471462adf905d769dc5267993b8ca6389e53"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=homebrew
      -X main.date=#{time.iso8601}
      -X main.builtBy=homebrew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    ENV["OPENAI_API_KEY"] = "faketest"

    output = pipe_output(bin/"mods 2>&1", "Hello, Homebrew!", 1)
    assert_match "Invalid OpenAI API key", output

    assert_match version.to_s, shell_output(bin/"mods --version")
  end
end
