class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://ghostunnel.dev/"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "99ebfe8f85f802f6cd06788444e964809d0890e2a875a715cfc13dfd0f8a4df6"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62cecacd94d66345af59edcddd3ca9d25aa94620d920a2e696ebc34ba6b2c0da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24a6aaa682181e48a0ce0e7becd6cd71f549d2b2e8f865d594e7fc12be6cffde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e95c030e89c8f91fc8c1475cc9dc4645a85f1fe1a7ca87c9dcc20312fa204378"
    sha256 cellar: :any_skip_relocation, sonoma:        "c28dd63ac2e50a83e1d1feac98db5a2afabb0ee88ac89684bebb12e84fea8762"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a5b68ee2975bcca3839375b9b92ef5cab67f05f825e1ef413d5d14eed76a3b5"
    sha256 cellar: :any,                 x86_64_linux:  "007db12eaeb3ea7d9ebc8c92cd0becd68a354b051891c0eb5b0885a5f3bb207b"
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
