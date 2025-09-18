class Ffmate < Formula
  desc "FFmpeg automation layer"
  homepage "https://docs.ffmate.io"
  url "https://github.com/welovemedia/ffmate/archive/refs/tags/1.2.0.tar.gz"
  sha256 "a4c01430041863cd5d7a6ff6935bece7c82f0d7bca94f79a77366c2e784d30b7"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cfee05bccc5257ea830eeaf08eec41f221a8be106a7963bc8a74830b62d0e76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58aae0d2682a7c33b00f0698feca3ec4c78d088c6621919bb243b7aebeb42ee8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc7181eaea7b27e22c41fb4b990550440e3b2ade0612de5a76db31369bcf977b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b01ac2e24f0b43f6977dd26b8c2fdebddea2143d26e4bfcd2b551d93a3b03c25"
    sha256 cellar: :any_skip_relocation, sonoma:        "79ffd6375fbac01e663f97e9db07da1f5e6e615dda5df9608cf37fa230122b50"
    sha256 cellar: :any_skip_relocation, ventura:       "21edba16e9504ac493edeb4adefc2223a352677aa42451740e3a1fc3afa8681a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11450a040b44fc1016a7ad9666e26e485a078ac3204fca95e4ed37e38005c631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd8a05a9ad42625356760918844fc1162e88c4679168e01215faa0eeb4e42353"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "json"

    port = free_port
    args = %W[
      server
      -p #{port}
    ]
    preset = JSON.generate({
      name:        "Test Preset",
      command:     "blah",
      description: "fake it",
      outputFile:  "test.mp4",
    })
    api = "http://localhost:#{port}/api/v1"
    pid = spawn(bin/"ffmate", *args)
    begin
      sleep 2
      assert_match version.to_s, shell_output("curl -s #{api}/version")
      assert_match "uuid", shell_output("curl -s -X POST #{api}/presets -d '#{preset}'")
      assert_match "Test Preset", shell_output("curl -s #{api}/presets")
    ensure
      Process.kill "TERM", pid
    end
  end
end
