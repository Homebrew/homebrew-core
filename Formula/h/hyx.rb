class Hyx < Formula
  desc "Powerful hex editor for the console"
  homepage "https://yx7.cc/code/"
  url "https://yx7.cc/code/hyx/hyx-2026.01.11.tar.xz"
  sha256 "550863c9e6a2c0e2618c16a562c8ee995e88c1d30e62abfdf4ecb819b3c4df54"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?hyx[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02dc7c7794bf71ba86674791229d5a5a128e3b65a29e45a277138f488ecb0b7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c036ff1df80bd3f6775c65cc746cef1b78de719338b2cec813183e4e18a1bd83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "331d208afd17f67c2d297451462f66394d729c8260ed95fbe3b6f8baa7ad9da0"
    sha256 cellar: :any_skip_relocation, sonoma:        "551a6a0ff4d2e4511f8d9992905f1ba983c2b30badfba6f5be0cffa62b83240b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0185c1cc5db86b21db59e9519419e65b7f70d118d627f363a7318aafbf2ce69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66f76d65ed139e22da8c4425dae64c28ed56c5ede6de83d57288d5e4dce5045f"
  end

  def install
    system "make"
    bin.install "hyx"
  end

  test do
    require "pty"
    PTY.spawn(bin/"hyx", "test") do |r, w, pid|
      r.winsize = [80, 43]
      w.write "62726577:wq\n"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
    assert_equal "brew", (testpath/"test").read
  end
end
