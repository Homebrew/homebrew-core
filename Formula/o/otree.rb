class Otree < Formula
  desc "Command-line tool to view objects (JSON/YAML/TOML) in TUI tree widget"
  homepage "https://github.com/fioncat/otree"
  url "https://github.com/fioncat/otree/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "d1bfb69c22b667a3102a33e879175cb2a883456123fafdb5cf2fdbbf23fbab10"
  license "MIT"
  head "https://github.com/fioncat/otree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "544a1df36ab809149ba5fc0199e3c7ce1cd74469c1a09c1cc2f9f89284b3d1d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62e01f50768e8ae21aaa986aa54870f40a204c31b94fd78fab775ea02772dd61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ce7feef0ba1ae948b2806f2b9bf4a8146b6955e8f6ab8553906448e4dd9992f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2da3b1f383e3a5276ca3ffc7d887603e211c285dac9113856a1bdb8733f4c07d"
    sha256 cellar: :any_skip_relocation, ventura:       "9aea34c04e62986699148a24fc25a6145a83197546c490b885814979c31e09d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "944bc56d293c7dcac2a0431939d5c7b57daeaf85cc7d870bffca32938702cf82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eb2a28a8e2fd9baa127a64e26093a345a629acf84f97e978a55f11cc7053505"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~JSON
      {
        "string": "Hello, World!",
        "number": 12345,
        "float": 123.45
      }
    JSON
    require "pty"
    r, w, pid = PTY.spawn("#{bin}/otree example.json")
    r.winsize = [36, 120]
    sleep 1
    w.write "q"
    begin
      output = r.read
      assert_match "Hello, World!", output
      assert_match "12345", output
      assert_match "123.45", output
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
