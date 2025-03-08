class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "7af498ad1a8d8acf6af9ec47e48f1b4898e645c76ca0b043bba49471d15d647f"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aac3ef5ec21aee59babc269c53b8eb8ab7e5cc9197eeae06ed948a1a6a6d5f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e65b6a719349cf1dbadfe7b46aa76f5f7365d37fc6d0bd904d9165606655b5f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5c091871f664d416c12dd25231cfcc98704b4f95b97ade23207d0d7e41ededb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cbe8428954428e026a99077c6522ac4c6ce9bf02c716052425187794e8c1202"
    sha256 cellar: :any_skip_relocation, ventura:       "18f93c44a50397f387f683f72cf926b983f9e4818e7053f6392868b319c6016a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22bc5455264ea616a2080486fca2043d557a4fb5493b29e6ac64fcd7cb24894d"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    system "go", "mod", "tidy"

    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output(bin/"gollama -v")

    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{Formula["ollama"].opt_bin}/ollama", "serve" }
    sleep 3
    begin
      assert_match "No matching models found.",
        shell_output(bin/"gollama -h http://localhost:#{port} -s chatgpt")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
