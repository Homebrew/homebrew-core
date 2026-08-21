class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://ghostunnel.dev/"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "77d369f25ec0f8439b198df7da4eae4aec901e16a8b39965a6fc14f15c80a002"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b23797e1fc459042d88eddadc344512340c949976a2431d438808e2d8577560"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ab68efdf0e6b53feb566f48d34f226b947fffe4dc18b1cd86d2c68a2a2c4768"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f44b67b2c047295b7f53b9f9e799d04832a3583ba826c055c10d6008d4ef6d37"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a4106ff7f0b52ab4d56dd2b2d116abe5a66db289b9cad14a35c7dfcf0505288"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1a7edee686818591d4a4411d339df8bb8f6483e65284e96e8e6fc991ff13e05"
    sha256 cellar: :any,                 x86_64_linux:  "929a44f81c0a4499e843205b1fab44be4543c1ee04c8c18e90d057e78965d9a1"
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
