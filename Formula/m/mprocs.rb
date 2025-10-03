class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://github.com/pvolok/mprocs/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "a058a2806319a0a1ab644158b741e9a54be28540c88d15d213b820b3f97a65da"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ba91419cf68700c856abb7d5806cce26aaae728048374f853b810e4c5381b0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16b81feda28c9ef5d6d17f3af89d567621202003b1058539f2acf42f8122f209"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57b9fbf1a21a53138d17727e206e82e870bb3ac1266d06a1133a995b635613c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62f383588660e5fe18d590a55819e2a7e8a3bf037f43acc492edc86f382e80fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1f2e9b460b58a527c5bb7044bf0cf9ea98250b7f10961181217d33c214d9687"
    sha256 cellar: :any_skip_relocation, ventura:       "da98d732c46c8c012a97c5299308284d478b356caa78b43491e3d18813a0df18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "276df3845dfce0965cc2a950022460fc9708b52a59697170aa24a206578a112d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86eb399ea7db2da667f42c18cc79c6b612465e04443ddb91430ef0c5d6180a36"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build # required by the xcb crate

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "src")
  end

  test do
    require "pty"

    begin
      r, w, pid = PTY.spawn("#{bin}/mprocs 'echo hello mprocs'")
      r.winsize = [80, 30]
      sleep 1
      w.write "q"
      assert_match "hello mprocs", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
