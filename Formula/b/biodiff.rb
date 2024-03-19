class Biodiff < Formula
  desc "Hex diff viewer using alignment algorithms from biology"
  homepage "https://github.com/8051Enthusiast/biodiff"
  url "https://github.com/8051Enthusiast/biodiff/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "f7960914ccf9b5fbdf3188b187d0cd3bca00f211487aa01d7b6f580da1c32312"
  license "MIT"
  head "https://github.com/8051Enthusiast/biodiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6c53d1d3d51623b51f60500e848722328ff6f4fb70fa87bb150d128a437735b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "195c79d4de3265849c382634d59331f8315b4afbb206ab47a9b12fe1fe07523e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2b7d5ec8bf5ab72b8dd796c5fb121df2d8df76cb6d381bb363146aa43c07dad"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3d8b9fae54b1f9d0baa13d3fd417e3a70901060dde6a6b69bf29ba82b41e11c"
    sha256 cellar: :any_skip_relocation, ventura:        "90b3895d3bb79f6584b6abd85d814fd108945306cf90b6b7cf185f3996b91f0d"
    sha256 cellar: :any_skip_relocation, monterey:       "987c0e84e8a6ff69d153310ed985b3d498e26cc39a0954bfb8a463a36c4ccf0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28b668c882b37f9edc86bbe6eb95ec691ad2e9963dd2e68537b5f9d98aec495f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    begin
      (testpath/"file1").write "foo"
      (testpath/"file2").write "bar"

      r, w, pid = PTY.spawn "#{bin}/biodiff file1 file2"
      sleep 1
      w.write "q"
      assert_match "unaligned            file1  | unaligned            file2", r.read

      assert_match version.to_s, shell_output("#{bin}/biodiff --version")
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
