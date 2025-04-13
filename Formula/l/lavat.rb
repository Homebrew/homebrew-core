class Lavat < Formula
  desc "Lava lamp simulation using metaballs in the terminal"
  homepage "https://github.com/AngelJumbo/lavat"
  url "https://github.com/AngelJumbo/lavat/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "07b11ce4d15354d8fbb85b60955c74d52d72946d509ec7dda02498adc71e2df4"
  license "MIT"
  head "https://github.com/AngelJumbo/lavat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38711addd8f972b79986ae0bbaa31468cf7d90ce859835bf7a48e25a97c5b93e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa92f862f00dff1a0d2e8d0c54ae9b3ca03e3318b84926fc191159a3705ea13a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa35b73d1492a19eafc5bbd3302a1077edaa9b278e693d9794bc277e3612ec48"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e47c15c73dd362b47bf2cbf6a41a331f74d2e52d66a8ce400799f22cb832457"
    sha256 cellar: :any_skip_relocation, ventura:       "374fe07d517384128561390cb971d836add8956932030f29062df39e97f3e23e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "755983a2b14cd7dbc52a2f2681765a16b8fc14979e383382597a3a9da9343141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25c91db37d725ae7e134e65cc7151e104e57dc0fd0adf2b431feb1593bb00a9b"
  end

  def install
    system "make" # `make install` doesn't work on macOS
    bin.install "lavat"
  end

  test do
    # GUI app
    assert_match "Usage: lavat [OPTIONS]", shell_output("#{bin}/lavat -h")

    require "pty"

    PTY.spawn(bin/"lavat") do |_r, _w, pid|
      sleep 5
    ensure
      Process.kill("TERM", pid)
    end
  end
end
