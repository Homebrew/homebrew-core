class Parqeye < Formula
  desc "Peek inside Parquet files right from your terminal"
  homepage "https://github.com/kaushiksrini/parqeye"
  url "https://github.com/kaushiksrini/parqeye/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "142fb53d92be4f65888cd463b2bae52d0aa23fab12aad2fbb2ae059f69b9978d"
  license "MIT"
  head "https://github.com/kaushiksrini/parqeye.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16c83459fd4b340717e1bb37fd61a112932dee6fa12036446e4f11a0bafa6bae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c039bbf9f1e135278183c63a5e6e986af2ac374e422da55db395018803cfecd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2050ec690944a6603f878d44f4204d8e07c1f5c2308fdf2d58b4a5383982f509"
    sha256 cellar: :any,                 arm64_linux:       "6c7a480adf7b6e5e47cfd8d0a84f52bb95823c04de0c990dbc501ff0f5d1fb5a"
    sha256 cellar: :any,                 x86_64_linux:      "c81845adaf21855a76eda8e140a528922dc5e7f14754722d0b6d8a3f763b10e5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parqeye --version")

    (testpath/"test.parquet").write <<~PARQUET
      PAR1
    PARQUET

    cmd = "#{bin}/parqeye #{testpath}/test.parquet 2>&1"
    output = if OS.mac?
      shell_output(cmd, 1)
    else
      require "pty"
      r, _w, pid = PTY.spawn(cmd)
      Process.wait(pid)
      r.read_nonblock(1024)
    end
    assert_match "EOF: Parquet file too small. Size is 5 but need 8", output
  end
end
