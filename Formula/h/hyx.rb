class Hyx < Formula
  desc "Powerful hex editor for the console"
  homepage "https://yx7.cc/code/"
  url "https://yx7.cc/code/hyx/hyx-2024.02.29.tar.xz"
  sha256 "76e7f1df3b1a6de7aded1a7477ad0c22e36a8ac21077a52013b5836583479771"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?hyx[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "585c67802079a4dd6d7ac7dacbb6fa218a6a491ba32b1926277d37e24acbc489"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dd26c1c352925782b4e7d45785b76f40f245fa2f1dbbc98f9cc4f2d3666cfa58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f55cd07a556e62e1b0264f158397ab1a13ee78ceed580c499b40b8f4158a8a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa1142ffce4cb48c51d90fa02b8dfcf43d9685bae6011f6ec072b71bc916035c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab078d0fa36bef1b72850c4a355268afaeb8f889fb96cc14d4ac0fa0292727c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f084d25734ace46da19988e530330c80da3aee8d09b474ed151c0fe67ee45ca"
    sha256 cellar: :any_skip_relocation, ventura:        "3328518acd239a750d5abf4aa64ce03a5cde6ba9e4d295008ba88211bf6da8fe"
    sha256 cellar: :any_skip_relocation, monterey:       "652226492680dbb33afac3764bac50c27386811d37922f08c487ef0086b3426f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dcbfd8ea3d3bf741858c96956174d8813ddd1e925c334643cbcd7883b0dbdf10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caa4542a609e244b3d83ca4e45e3fb9a71d3fa77e8ba0346803b24f63cc205bf"
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
