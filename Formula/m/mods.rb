class Mods < Formula
  desc "AI on the command-line"
  homepage "https://github.com/charmbracelet/mods"
  url "https://github.com/charmbracelet/mods/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "67adced6190624824636fb80b5185a8606e3ad9c821d7e8f931d6d3822da51fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d24a7f73e92a010a99a2ed7e81de2060da85d54ea48cebd1c386a854f1d6dc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d84560bc5fb265405bd3dee9f38367cb1d20129e359c7c7007f47e55d1cd2c44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "950957152be2d9d101cab9bc0dd4f1a981495abc5e3c1aa362a2424c6e1033da"
    sha256 cellar: :any_skip_relocation, sonoma:         "09bd029af5d892ec73ce21b23e9895f46fc03e5de9ffb0ec0455dddf91bada98"
    sha256 cellar: :any_skip_relocation, ventura:        "40eefb81c32eb6710047f87f42b94824249e0c29e003441ad714af7e783c80d6"
    sha256 cellar: :any_skip_relocation, monterey:       "67094fb6c89797a67b140eb0308c7e67541e051398d9c592a9b6033f061c04a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0db21ede97c7bf52a7211c378a68f7b00af2dfbc704d0e396c3c8b63a4659eb9"
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
