class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://github.com/sigoden/dufs/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "da4b64add0df9fca1e38e416a8c265b57dc66e02d6256d1b34db12f9b5d7a962"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fef5d9dc7e6126dbf2388a13a21ff6b85a4dc773f4e85520d54cce64ceaf71d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae3634d6733928b6ac17150ea9069cf8b43d499491c0bde116b7c18433b9bee4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bde8984a9b693329fbe79417a5fdd0abdf5cda308de563537ed0998a430b9973"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5e3d5d6eae8dd38a2190cb732bbaf8bbd546b5849eac2a426a3bcd345174ef4"
    sha256 cellar: :any_skip_relocation, ventura:        "aadb18d5c6ce409fd4dc681ee7dfc150f0b2ed017afcc93cb223a023f615ef86"
    sha256 cellar: :any_skip_relocation, monterey:       "027e011f8ad013c0f926bde4175224fe9c462dc8cf27a3dc9e32e4a1d86adb2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c71b755cd33e5b4f84837bc851ee56cc14b5b8a805666358bc181169f7c663c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dufs", "--completions")
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/dufs", bin.to_s, "-b", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"dufs").read
      assert_equal read, shell_output("curl localhost:#{port}/dufs")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
