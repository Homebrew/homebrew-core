class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://ghostunnel.dev/"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "3b7221a474d39cd56598a874d5d9b27b20ebb857c655899b5c6960ccfa3b6a30"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d7156435b018d4c1589b0d6a88ab90c89447c99f06f2768c7ebbcc0ad9cdfc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad39cdca5d33ee2e750425871af0261aedc045203dda103d0c935803521035cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f696c4182c2db6904823945fbcbcc03cc6d417f07ebabea8c875c938c9cb0caa"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8a35e80671eaa28915049a85644e81ef4ee2ddf11089266efdeb8248ae37a2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54132df9e01178cac4bf8994120a0dfc05090c51d34e290040226dc04a800d8a"
    sha256 cellar: :any,                 x86_64_linux:  "a79ade180fa57779b58c096974559ed0618198cb06223b2d1849a4ce2830d88f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

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
