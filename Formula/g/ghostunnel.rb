class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://github.com/ghostunnel/ghostunnel"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "0a3a00748d837216051fc1ab031be66a2c937acc9e6bf877d18a4fdd397438e8"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a8c10137e1a3b8196b5b76cb505d7245b41316705635fb57b4e32e51e5fca1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7079cb1ba4a200609b4ebc49b4bf2cc836bd5145d4e9a0c6e7695c3f1aacfccd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c7ac65a9075a3299de812b6b4a838e08c6d54fc3b034b2d13af96afa02418b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c92f37cfb2c48751fad6924114b15e1864abe8fcc688f8f78ef10fb7978555e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a151351ff39c3dbadebf9644a6e47823d5e8b224b1d7e5d3a112248f2c333de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e82f286be8599524da6b5c2eb19f4cc2f1e254cb7f5d5520c48a6cfc3daffe6b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"ghostunnel", shell_parameter_format: "--completion-script-",
                                                           shells:                 [:bash, :zsh])
  end

  test do
    port = free_port
    fork do
      exec bin/"ghostunnel", "client", "--listen=localhost:#{port}", "--target=localhost:4",
        "--disable-authentication", "--shutdown-timeout=1s", "--connect-timeout=1s"
    end
    sleep 1
    sleep 2 if OS.mac? && Hardware::CPU.intel?
    shell_output("curl -o /dev/null http://localhost:#{port}/", 56)
  end
end
