class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://github.com/ghostunnel/ghostunnel"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "6700ea0ae9a83df18aa216f6346f177ff70e6d80df16690742b823a92af3af46"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ec1ebfd92444053c51500764c2b2ff9a68f63f589443b976aafa8d01b600db6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c224c228e987028819e5d11a479f03ebba9173fe8efc946c00bf1df7820a8472"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "352ef0ea3c5832ce3469d5fa44d2820a9d9d1dc691f7189057a9b8fb5b450ff1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2fb4451bc2b01b7eb2322c1b5477b97bf770deeb6476da7009e5f95a6873811"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1e1083b6d3476a7ffea3a80471e54d120051f5b9283cc0755a6b3c20a57c8d9"
    sha256 cellar: :any_skip_relocation, ventura:       "b6bd8fc84a044dac20a64b2559742e404d5a1e69bea41bbcffc623c14c939e1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6782ee6ff76538a6681c530f078da7ab66560e32ed4265d948a10a7e3e6a06e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ede20e59499a513433440f3d7c7b3cd2eef379baf06222fee5bc502c9bccc65"
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
