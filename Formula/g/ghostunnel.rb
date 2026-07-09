class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://ghostunnel.dev/"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "fd5757ca08f60f29bd0997dbf285f0a94a77e7e6d115467bea01027791e963b0"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f467f526f44a0f13081aedd91688864fefb53d81b29b2c1b8ffff6cdc976dc28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ea8eba0acef173c9023f17249c6327661be5d2199121c7fca231d8b673e1e54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b667d848ac735d7b7788c3fafa0234882f559704faa0d0d2d963c4e8755bc18"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d78660e046fac63aef07db421893a57a15913cd0609a1247fdad430d59dbe09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ae97e929b65ca64471c0c1227ce531e07c91e45de2fbd0260b0759152e3b1d2"
    sha256 cellar: :any,                 x86_64_linux:  "272387e86bbde71ca40e01076819f85efc4c9d639c28aa39614dfb8157da90f4"
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
