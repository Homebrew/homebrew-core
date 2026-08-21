class Parqeye < Formula
  desc "Peek inside Parquet files right from your terminal"
  homepage "https://github.com/kaushiksrini/parqeye"
  url "https://github.com/kaushiksrini/parqeye/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "2b8bc834d91594a708d2eea47f0e9ed2fe79b79dca1e9cad631d20b563a612c3"
  license "MIT"
  head "https://github.com/kaushiksrini/parqeye.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0ca576b3be6ce10c5976c13636762b613d16e5027f98572d9ea929e49666e57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5af5b8e308ae68a7b9905b3af1bf7d696e159f94c4cbf263d87e87c06fb682e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f910d4ab0ee3bfb6ad00fcfc7316cd8332360215531510cf011bfdab5bcb29f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5148fda025624a9bdc164e1f98753b7955486a6c1daffdbc29d25aa011477971"
    sha256 cellar: :any,                 arm64_linux:   "5fcb5d393a5694a69b84139a5f584cacef1851f14ddb55a7a71a908220616127"
    sha256 cellar: :any,                 x86_64_linux:  "212e477be3a01fa865ef57d13974ce976551e358ad88e4e899ee75ec76cab640"
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
