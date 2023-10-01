class Mods < Formula
  desc "AI on the command-line"
  homepage "https://github.com/charmbracelet/mods"
  url "https://github.com/charmbracelet/mods/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "7272c4062095c63e6c8a2cc3b5233bf9261a027237512123c073c2128284e6d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13760592d727f5369869e3fd76ab323f6f263c189f996403ee8d71125dc00704"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80c5a80865413a35f96309759a88ccf52bcd3cda6d82ce67ff856e007262fde2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fad46cf1ae5df42f505a4b4b8ea42aceb31fbbc03c5739e99a103be247b80bac"
    sha256 cellar: :any_skip_relocation, ventura:        "3559e0119d53d36127c11fb4d414c22fd5762d72a4c9ac67d9db29b3189a16d3"
    sha256 cellar: :any_skip_relocation, monterey:       "83809a1894cf76d40af463a24347abc69a1ab889d9a798d6c99948a170b55bba"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a005be424f46fc92da62904c5608b0dcdf62670684b762703696ace5ec107da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11d734ee693fb5aa3f04d8edd949437967b8ba5ef4d48e269860863b056c83a8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.CommitSHA=#{tap.user}
      -X main.CommitDate=#{time.iso8601}
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
