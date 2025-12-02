class HttpServerRs < Formula
  desc "Simple and configurable command-line HTTP server"
  homepage "https://github.com/http-server-rs/http-server"
  url "https://github.com/http-server-rs/http-server/archive/refs/tags/v0.8.9.tar.gz"
  sha256 "b385a979946efb9421f49b698ce9fe1f0e590a96797e72e8e441bebd6ce65bb6"
  license "Apache-2.0"
  head "https://github.com/http-server-rs/http-server.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0a809086a7ca4186c1f20e8ae46b1f5aae4af25494c69a4c3bdaf5463d94fdda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fe010697a6d9851c061d2939929b4e6f9750ad2612ba486b35610175da62c604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6f29de99576b74d2398a7fc093bc700a3de1d7d5c1db98224c3750c1ae79226"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07f0f7eaf185964fa80e46e9b0b797c8f454345fb3eb72d21ca618379c59602d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02223f122e30366797da3e9016ce454653dc8db7a07f79fbd6392aa42dee20a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "9fd1a8e7f2e528913edb6e48b07d03d61b7b39e63173b77e64696394a5f33318"
    sha256 cellar: :any_skip_relocation, ventura:        "2b555ba245fc88ce42aacc38c80c1409176d0f7900d85945609111bc3bdf6573"
    sha256 cellar: :any_skip_relocation, monterey:       "6611eb126def91614acb470f6393229f827905ee621fedf4f3791f8c94cff625"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "619764056faf97e193acababdbd3afc2f94c239dbfa695cefc953836445d653f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "580cdfea1cd7aacdc67e69c5db6e16f057c8a459c8567b0eea601628c30352b7"
  end

  depends_on "rust" => :build

  conflicts_with "http-server", because: "both install a `http-server` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"foobar"
    port = free_port
    pid = fork { exec bin/"http-server", "-q", "-p", port.to_s }
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}")
    assert_match "foobar", output
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
