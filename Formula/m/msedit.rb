class Msedit < Formula
  desc "Simple text editor with clickable interface"
  homepage "https://github.com/microsoft/edit"
  url "https://github.com/microsoft/edit/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "f35da309c5f3d92b10e5c4b2267e4d5e29d809b2aa460e80326b11f7feba72a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e53e7fda41c9669f4d7c785352edd9b93b2257c1219b4ee3600eafd4133c7d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43f68f519638f1ed15f065e7d64ab430719fe6a0d6eb079a40f712e61241caff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57b1a88073cfd839d44753664d27b2136354b4e0133bdc012629821ef2c365d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e967b1a1ac73c7785e2aef74051c6af6bfd04a7e59f0b3ef1e6954804c53699"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9c65558ba93a129afafc88465df0b48b2450cce879e1abe131ed45a6a015d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74d042709b9bff1f75811558cd6cb5a8a442d2126cf1edbc559467c6b7cd3abf"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
  end

  def install
    ENV["RUSTC_BOOTSTRAP"] = "1"
    system "cargo", "install", *std_cargo_args(path: "crates/edit")
  end

  test do
    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"edit", "--version", [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn("#{bin}/edit --version > #{output_log}").last
    end

    sleep 1
    assert_match version.to_s, output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
