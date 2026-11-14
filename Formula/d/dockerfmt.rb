class Dockerfmt < Formula
  desc "Dockerfile format and parser. a modern dockfmt"
  homepage "https://github.com/reteps/dockerfmt"
  url "https://github.com/reteps/dockerfmt/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "3bbed8d06a049bac352cbb06b7a369439578896f63a6995d1ac6b52c7b7fed52"
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
      from alpine:latest
      run   echo hi
    DOCKERFILE

    shell_output("#{bin}/dockerfmt --check Dockerfile", 1)
    system bin/"dockerfmt", "--write", "Dockerfile"
    assert_equal "FROM alpine:latest\nRUN echo hi\n", (testpath/"Dockerfile").read
    system bin/"dockerfmt", "--check", "Dockerfile"
  end
end
