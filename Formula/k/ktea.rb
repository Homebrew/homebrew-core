class Ktea < Formula
  desc "Kafka TUI client"
  homepage "https://github.com/jonas-grgt/ktea"
  url "https://github.com/jonas-grgt/ktea/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3bf694bd583e0e655a3540c4d812e64726db632f4e7080d4cf9fbef4b1a3d363"
  license "Apache-2.0"
  head "https://github.com/jonas-grgt/ktea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba120d2a3ebe8797d35a7e776358c06a4f741c8d1b14ae624ece0554c85fc19c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba120d2a3ebe8797d35a7e776358c06a4f741c8d1b14ae624ece0554c85fc19c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba120d2a3ebe8797d35a7e776358c06a4f741c8d1b14ae624ece0554c85fc19c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8537976c5e1629a28caf0413542ec0fd35ff4f0a20b2b9f5d5c1d5594ccf9c7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a55355631ba40c61b309efeede7154d0b07137df1c817d6f6112fb012f76d0d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21177f8146ad242c92aaa340e4558369987fbb62395c423becab0e22d85c5292"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "prd"), "./cmd/ktea"
  end

  test do
    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"ktea", testpath, [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn("#{bin}/ktea #{testpath} > #{output_log}").last
    end
    sleep 1
    assert_match "No clusters configured. Please create your first cluster!", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
