class Mods < Formula
  desc "GPT-4 on the command-line"
  homepage "https://github.com/charmbracelet/mods"
  url "https://github.com/charmbracelet/mods/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "2e855a621406289b374068ebcca4a9613d1c64ce64754695c269322698ce73e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ac233a04962f8b085491501259dc66fed0338b915bc7a510b31df8d4a4d8087"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ac233a04962f8b085491501259dc66fed0338b915bc7a510b31df8d4a4d8087"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ac233a04962f8b085491501259dc66fed0338b915bc7a510b31df8d4a4d8087"
    sha256 cellar: :any_skip_relocation, ventura:        "eced1ffb485fe032691269c2c46521a6eeed0ff86c5145a10e4eb4cb3ee63fd2"
    sha256 cellar: :any_skip_relocation, monterey:       "eced1ffb485fe032691269c2c46521a6eeed0ff86c5145a10e4eb4cb3ee63fd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "eced1ffb485fe032691269c2c46521a6eeed0ff86c5145a10e4eb4cb3ee63fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1af3ffeb79b00f9dca2473ad770c9a27aebec0379f28026cb4805f9a78bc5a6"
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
