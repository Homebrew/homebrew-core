class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://github.com/sigoden/dufs/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "bd77bd4d9a5b244703761e7a745c9b127a271612f24d076d99abe758e0130a90"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "382ba9e7e6114721a5d119399f9fa762a0a2fd29a3dbd50b1ed9385db5e5173b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26e1f2bc5f8223f85413ebafeb6b50b94c1cd4e5e5a0680ae5fa842f86610d81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be382b2f7e4728d8a1bbeb7d3b89660b5763150b597f4513a550f4ea01c3911b"
    sha256 cellar: :any_skip_relocation, ventura:        "99847a256a2d12da09d7899b1111bbaeea8bb0a248f94960b0dfa6ecfe2f1a6d"
    sha256 cellar: :any_skip_relocation, monterey:       "0d9bf3e14de11397297ef965cc856c20ff85d569c80204b014674bed3a7c126a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9a256f521453cb96955658b6ea5b24072d44bf278e94959bca1ff54b693236a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e26ae0ef34ea21e2bb520748650f3afc76af97a0598329b7004d5215cff6830c"
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
