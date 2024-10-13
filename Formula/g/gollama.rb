class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.27.12.tar.gz"
  sha256 "4e3682e2624d72b5f9a2b1b3d6aea57579e52a8ca0b8e09844f852ee00760660"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29001a9f678f0ab63eb71a3a71fc154e7713479e5067fdb3a13a71cc618f5aa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "885bdec008b02d4cf73e6fe56189ced1ac3590b1f2ac0b5f1566bc2a77544c10"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e902a57b24bf30bf66412f72014a30858ff3dbfbe058d36bf3989e60db036ec0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6f42471a263dbbf433dc99c50a0952f4fc1f3459b3730c91a709d924ddc9683"
    sha256 cellar: :any_skip_relocation, ventura:       "c1320be1b70016576989979942d1e1d5af0d31a7f34eaa6e690ef0266cdaa22a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d70ac6921cb976184cccae6eda9618fcba8ef9b69b0ecd3ab2a41f66b1a71d2e"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
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
