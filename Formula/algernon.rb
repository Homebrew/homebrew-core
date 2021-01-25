class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/1.12.12.tar.gz"
  sha256 "6127eb975da960fd8aa7732c82f3b5e62d14ea763801778552bdbeec28846bf7"
  license "MIT"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4cf045c65143ce6cd0b8eac6014609840a8ea8a524cbf1b1fc01a324300fa36a" => :big_sur
    sha256 "d6ba614c6586b6d582e06b863298ea48256dd6e6b4e96cb009b663cf6198afe1" => :arm64_big_sur
    sha256 "5cb0074f58de14fd079892387ed83de4636faf52ef0081714b7c1f0f9b7469c5" => :catalina
    sha256 "0fd0ffd941bb3399a63e38c20d9a3606fb390ae3b76e79fa055fbd77a71939ac" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-mod=vendor"

    bin.install "desktop/mdview"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match /200 OK.*Server: Algernon/m, output
  ensure
    Process.kill("HUP", pid)
  end
end
