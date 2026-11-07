class Dockerfmt < Formula
  desc "Dockerfile format and parser. a modern dockfmt"
  homepage "https://github.com/reteps/dockerfmt"
  url "https://github.com/reteps/dockerfmt/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "9e631544b9cdc1fda8c0380749ecb37a45574762b0e2ccbb17d7d93d66f46cd0"
  license "MIT"
  head "https://github.com/reteps/dockerfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e0309e2568e546e910828093cea4f5bf909528923d9105bc0bae0e74e9412d91"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e0309e2568e546e910828093cea4f5bf909528923d9105bc0bae0e74e9412d91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e0309e2568e546e910828093cea4f5bf909528923d9105bc0bae0e74e9412d91"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "890fd720070c57747d05315cf7ef98616dc7aee14b87eeb61c256fc5dc3cd98d"
    sha256 cellar: :any,                 x86_64_linux:      "6455bcd91cff82a42b956b86e71a0c75889d0ae17b9b678e98cd71aa0fc2b353"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/reteps/dockerfmt/cmd.Version=#{version}")
    generate_completions_from_executable(bin/"dockerfmt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerfmt version")

    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine:latest
    DOCKERFILE

    output = shell_output("#{bin}/dockerfmt --check Dockerfile 2>&1", 1)
    assert_match "Dockerfile is not formatted", output
  end
end
