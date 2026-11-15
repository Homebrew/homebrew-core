class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://ghostunnel.dev/"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "4e422caf02e8fc2082f749f56b37dd64133da0e288cebdfdde52be8537ead69a"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "87199dbe335f17356181a6939285733718c568b0e15ba39518ff4e6019756ee5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "138b3f258d98d08319b4ba8136ba3f7340e2643ea0ec63051143ba90cd0a0648"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97b6ac16d308143bdbffc49caeb9dbe85778094e465119bc77f6d70b964f24c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b15d8f9e08b41ac035d7f37285344c085e71b88371ebed08fa27eeba636683d"
    sha256 cellar: :any,                 x86_64_linux:      "c4c5ad8a61f4bef495166a06d61376a0df435f8b909f89142e15ea01735b1736"
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
