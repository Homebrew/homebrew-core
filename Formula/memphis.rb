class Memphis < Formula
  desc "Greetings from Memphis - CLI"
  homepage "https://github.com/Memphis-OS/memphis-cli"
  url "https://github.com/Memphis-OS/memphis-cli/releases/download/v0.1.0/memphis.tar.gz"
  sha256 "2bb20d936b954ae90fce487c7e25064b854d86dada89ceb565e467262d708566"
  license "MIT"

  def install
    bin.install "memphis"
  end

  test do
    system "false"
  end
end
