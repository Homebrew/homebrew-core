class Lavat < Formula
  desc "Lava lamp simulation using metaballs in the terminal"
  homepage "https://github.com/AngelJumbo/lavat"
  url "https://github.com/AngelJumbo/lavat/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "c5364203a75395953560b173fae90c316b753a046acb8f557c9e684eec6d76ba"
  license "MIT"
  head "https://github.com/AngelJumbo/lavat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f31fad68503809cf54692f4d288ce719cf7ed40072dbf82c4890122ad1b87674"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6755e230f40d6f712d4a1a73304058c8002e776b39a67c87042a3578d604d1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f96335eb525ed1fcd952a2e52c64191c3f7f81edf74d3d28afeb26db1bbcc487"
    sha256 cellar: :any_skip_relocation, sonoma:        "06cc6bb29764628d5cd862260b4e53f3adc807fc9ed508c0381bc69943567a6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1a3d35b4b53a479c21db06577fd62f3febcd9533ffa492de6607e4b564314d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be6f15d6675cca37066f21f6e9b5e61528f90d18ad29173e1b3019dd7937338"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
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
