class Glider < Formula
  desc "Forward proxy with multiple protocols support"
  homepage "https://github.com/nadoo/glider"
  url "https://github.com/nadoo/glider/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "709b17ed90b41ec6da063b4598f32350f5e849d93a9ca77ca19b1978c500cb97"
  license "GPL-3.0-or-later"
  head "https://github.com/nadoo/glider.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20fe3b519f03a24285ca44ff869b7d3808fb1ad76662dbcc0e1a9650d1022419"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "526b4ff13b74f255865b113d747f3fecabae3a66b22f7755879292580f7cb4b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "526b4ff13b74f255865b113d747f3fecabae3a66b22f7755879292580f7cb4b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "526b4ff13b74f255865b113d747f3fecabae3a66b22f7755879292580f7cb4b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "74da3527cc114c621e5a235ddb3c66c6963bcd8966d9ccd26b64143210d29ce7"
    sha256 cellar: :any_skip_relocation, ventura:        "ab7563d4c05ccabdbc569b10ecb9d9cbf479b463f4491aeb35e17f9ab64b75a4"
    sha256 cellar: :any_skip_relocation, monterey:       "ab7563d4c05ccabdbc569b10ecb9d9cbf479b463f4491aeb35e17f9ab64b75a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab7563d4c05ccabdbc569b10ecb9d9cbf479b463f4491aeb35e17f9ab64b75a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "079c2ddbf5802380f01e8bdb17ac4b90aa488e9eb8be87497c532531c779c9af"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    etc.install buildpath/"config/glider.conf.example" => "glider.conf"
  end

  service do
    run [opt_bin/"glider", "-config", etc/"glider.conf"]
    keep_alive true
  end

  test do
    proxy_port = free_port
    glider = fork { exec "#{bin}/glider", "-listen", "socks5://:#{proxy_port}" }

    sleep 3
    begin
      assert_match "The Missing Package Manager for macOS (or Linux)",
        shell_output("curl --socks5 127.0.0.1:#{proxy_port} -L https://brew.sh")
    ensure
      Process.kill 9, glider
      Process.wait glider
    end
  end
end
