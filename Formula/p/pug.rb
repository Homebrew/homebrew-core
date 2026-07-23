class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https://github.com/leg100/pug"
  url "https://github.com/leg100/pug/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "a65d9d6e381b8e3efd22e90b0088f25c048734072ec6f132a39f1b7c20e9ea3f"
  license "MPL-2.0"
  head "https://github.com/leg100/pug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f019b4a8fa406e46455d1fa1f1930a3e84ba7a8c91b27666fddefc3ee621de1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f019b4a8fa406e46455d1fa1f1930a3e84ba7a8c91b27666fddefc3ee621de1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f019b4a8fa406e46455d1fa1f1930a3e84ba7a8c91b27666fddefc3ee621de1"
    sha256 cellar: :any_skip_relocation, sonoma:        "762c86b31f69afa3270b3fd9179868bd4dbdef4c1092f7aaf0db0b00c2962ab7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8c3970a5617f14543750c7d4127744944d111e650c892e0528ec0245af15f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2583aa7db7860e667710770b11f021b1796dcc11cdc6c86feb33d8988f722b16"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/leg100/pug/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pug --version")

    begin
      output_log = testpath/"output.log"
      pid = if OS.mac?
        spawn bin/"pug", "--debug", [:out, :err] => output_log.to_s
      else
        require "pty"
        PTY.spawn("#{bin}/pug --debug > #{output_log}").last
      end

      sleep 1

      assert_match "loaded 0 modules", output_log.read
      assert_path_exists testpath/"messages.log"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
