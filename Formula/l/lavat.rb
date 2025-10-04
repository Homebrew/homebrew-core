class Lavat < Formula
  desc "Lava lamp simulation using metaballs in the terminal"
  homepage "https://github.com/AngelJumbo/lavat"
  url "https://github.com/AngelJumbo/lavat/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "e8ccda9798270838244bf60497062507cae75b6ab9fb198c54b5a005bea8b87f"
  license "MIT"
  head "https://github.com/AngelJumbo/lavat.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f684f1efa1724f5d7fe73d03eb9acfb5f79309a13561088894acb99fd7f2439e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7cb9e3e77b1074841570a1bd0b037bcee8d74e05784c8bd9a3f2a4ec4c6c915"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "741edf089aad5dc7dcb7c206daa13fb4e1dceca2bf2d6aeae3a5acedc68cbe5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05a6148c956b3d20ab3f27654ad1adbb0e7bd33c11d8af285beb289544d3aaea"
    sha256 cellar: :any_skip_relocation, sonoma:        "97af569d6ba26c924ae070218cbf6ffd2c53931b9f46b84433e2bf364fcc6c1e"
    sha256 cellar: :any_skip_relocation, ventura:       "0616d061e0e343fe7cc539b1dba77c3ca50e448788abf7df28c77ba95e6d379c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00a81e2dd91c2cb54242affeb77d967eb3af4f4b8394f6a4b97b7d8bc737b21f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b1f70e38f1cd377a86a965c50ae36662081e0ad44d171d41e5683b26d0da384"
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
