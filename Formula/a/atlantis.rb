class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "3267f6aaef1c7222548c322c8cbb37fc45a0efec5d23feab6834304f9623cb6c"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f20c3b051685d8fa515b674454baec5bdb43e83d4216355b6ee654fcb2d992a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ed09fc58baa9d4e4e7764c4e4ba6b2bcee0199884419bfaed6b07e9322d6233"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ed09fc58baa9d4e4e7764c4e4ba6b2bcee0199884419bfaed6b07e9322d6233"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ed09fc58baa9d4e4e7764c4e4ba6b2bcee0199884419bfaed6b07e9322d6233"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c22dbcf5c74daaf67efb6d61e11fd7fc3d01ccfc44694cbe962b098679082dd"
    sha256 cellar: :any_skip_relocation, ventura:       "6c22dbcf5c74daaf67efb6d61e11fd7fc3d01ccfc44694cbe962b098679082dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65b72d9a721cc871c38a9cfb21bbe906edd43dac9e11202eaae9c70acba9c487"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
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
