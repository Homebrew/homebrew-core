class Igrep < Formula
  desc "Interactive grep"
  homepage "https://github.com/konradsz/igrep"
  url "https://github.com/konradsz/igrep/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "c4ccd55082f2957dab3766b4c7229c3f804d578a8214ef2ce23f13029bdd2296"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "391741525996465c8daec9146826c5a7970ffe361a8587b420e627070f4ec583"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "434a63f52f457e3ab6cc31b65b9e68816fc7a61f68f207ce8256cbbdd821e638"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4d4909e6565fc5392780bd4e98ea21c7c3ac0c57c13de04718dcbae5d432f19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13aa62146a39d0ca77fd0447083250a91895c525366416a3a6b4f89cd7339916"
    sha256 cellar: :any_skip_relocation, sonoma:        "cec39eb06f65f3f609ed041178d24d9b421076c6bb5cde8b2b497f3f4c11e135"
    sha256 cellar: :any_skip_relocation, ventura:       "c3d75de9c19cfeef74696cac8f70b7ae883abe652b3235bdd8533f34c793f869"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b40c50a1fef708517db4d64b7847c46b6b0ddd0a2f2a28459a265b1c33077fba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b6d905e2675588fe40f375b699b30c314ac1e2b18606ce416d3ddac103ec4a1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"
    require "expect"

    (testpath/"test.txt").write <<~EOS
      This is a test of the Homebrew formula 'igrep'.
    EOS
    PTY.spawn(bin/"ig", "a test", ".") do |r, w, pid|
      r.winsize = [80, 130]
      refute_nil r.expect("test.txt", 3), "Expected test.txt"
      w.write "q"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
  end
end
