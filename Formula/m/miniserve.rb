class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "ed0619bfbad3f9ea635aa266a9c4e96247ad94683d50743f0464f48f9e48ae88"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10eaf772ec667da85603faae3841fd1c97f8abd71c69e36f8437713df106a472"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "266db94d57f71db517a095c477b11f7b1edb2422b25449cbaef3be4b8b28ebb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02244c2ca9c29060a039135a197186072aab8e19e9d6cc3c5d7583637afa0078"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9f51d601be25ef87759d99b22f932ad3140f9eaf3cffb73ab6d51e3a266bc6f"
    sha256 cellar: :any_skip_relocation, ventura:        "7de15afe3f05768643bd4fe97c311b354814f6fd2d2193b008d22e7224248ad0"
    sha256 cellar: :any_skip_relocation, monterey:       "e970a5810f2493527b9a7ff8b436ab2419773cf0acb5a7886ce4d4276ab8edcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6bc5dad231955be58d5f78e97ea27bd63679bc50da763124bb1415c8770c23b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"miniserve", "--print-completions")
    (man1/"miniserve.1").write Utils.safe_popen_read(bin/"miniserve", "--print-manpage")
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/miniserve", "#{bin}/miniserve", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
