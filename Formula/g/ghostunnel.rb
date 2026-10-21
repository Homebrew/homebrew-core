class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://ghostunnel.dev/"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "905eb81929a2f92e0d7d68f7db42bfb6d098b1ff0cd2486c95f2965034514264"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f8b7c2bc7d9000605636967bf3e6dd42ac66134d0fdb28e1f7b59ed11f9f9775"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ea7eecb64a0a8ef05b1785ec5178cd4eae49fb044a4c429fbdcc3c9c48aa008f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "96ae84b41bba980b76feacfbf8429ab868979b95fc2d31467363b9559355ce60"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0c1f6bdd435f65f6e4cef39cc14087fb05a825a6d15ece416046cf05d62553e2"
    sha256 cellar: :any,                 x86_64_linux:      "de6b6fe7c85e8dcab5eef74bf6a6ddc8296075187e0be5d2ddadac9177eeae74"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
    shell_output("curl -o /dev/null http://localhost:#{port}/", 56)
  end
end
