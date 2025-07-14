class Ffmate < Formula
  desc "FFmpeg automation layer"
  homepage "https://docs.ffmate.io"
  url "https://github.com/welovemedia/ffmate/archive/refs/tags/1.0.8.tar.gz"
  sha256 "fc5ce220b0ddb37ba05af9c5aa498c27163469fb9dbd3a962bf693417d033f6a"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e0eb7dfcb53c17edf9d497f5faa6c47eaa1be9bf2dbefe0e740ac12113283d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "676761f0a3fa4ca0c4d7d8f98a01ed0034a93d46eca7e3eb76a591e32043734a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfcda9104196a1fdf12099eb2ea3d7acf98bc6f817623fcc69c80dbcb73ff106"
    sha256 cellar: :any_skip_relocation, sonoma:        "6de50bb039379cba499e9729c4f16d9890e7aa1644f51c405fddb6a80611c127"
    sha256 cellar: :any_skip_relocation, ventura:       "8b504482819f7219dcb0ed35438308b5e5588ccb0ea84f806584eb1ac2461b8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e443c03bdbd2a9ef7e3b2fc9c4d6204075c074b6de60d5d304aaa434dd549294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "456d7c6fd91a203abd1dbbae09caf7c64c2d457f7a15724536f3d6f85cf02232"
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
