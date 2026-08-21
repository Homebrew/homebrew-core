class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.47.1.tar.gz"
  sha256 "6bcf0bd15d333f52ccadb59c699af19e5cb6980485284aec55bbac093b7097b9"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10439ca68f408b4d43478d4433d81ef16b5bce7fb50e887c7d1da0dbc0e6cfce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10439ca68f408b4d43478d4433d81ef16b5bce7fb50e887c7d1da0dbc0e6cfce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10439ca68f408b4d43478d4433d81ef16b5bce7fb50e887c7d1da0dbc0e6cfce"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f6e66753c46c5cfe6abb5ad097e46e10b4dfe775367b4e9ec0efdeca10cdca5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e219f331d665bfaf0dc4239669e0f3cc42e62b42671c2862be36e1dc2354cac"
    sha256 cellar: :any,                 x86_64_linux:  "00b695a46f8c263c41f71b38ffb7e98b17d7c059e04adae83a9f4318dabd815a"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"atlantis", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atlantis version")

    port = free_port
    args = %W[
      --atlantis-url http://invalid/
      --port #{port}
      --gh-user INVALID
      --gh-token INVALID
      --gh-webhook-secret INVALID
      --repo-allowlist INVALID
      --log-level info
      --default-tf-distribution opentofu
      --default-tf-version #{Formula["opentofu"].version}
    ]
    pid = spawn(bin/"atlantis", "server", *args)
    sleep 5
    output = shell_output("curl -vk# 'http://localhost:#{port}/' 2>&1")
    assert_match %r{HTTP/1.1 200 OK}m, output
    assert_match "atlantis", output
  ensure
    Process.kill("TERM", pid)
  end
end
