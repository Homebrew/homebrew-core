class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://github.com/ghostunnel/ghostunnel"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "88164c8a1f284b70ca5271fbd001f29967a40d3be23abdce316708118ba01915"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b90f610097add9b870ad29b07fb6659f55b475b0410820f2870d4b62f40a7c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b80bac1e574b48a0eb1a18ddad29d9c25ed789ac737acaf1e6e5a98cc77f54d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "920f7b9c1e275f29ad11d89c0448bb004ea4ea151b2a9f80ca5f44504f4cb426"
    sha256 cellar: :any_skip_relocation, sonoma:        "df424daf94f6d23d0b83312da54e7a086903b2b522f7902e542afe789977071f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2c73aa43c1bf08ae62db44035d052a8f726a76c063d3ab3127ffca63fb2a183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a360f85e6688fc6c565441a31ce217ae97afdf67d6a7eb91c0d0991a1bfffeb3"
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
