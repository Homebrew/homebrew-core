class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://github.com/sigoden/dufs/archive/refs/tags/v0.34.2.tar.gz"
  sha256 "d01f05744dca57b7dfc2d70c994b2532bf9fa4790d6fd1a5f87486eec2f2d95d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73eaeeea2f66a33e6aa8be920efa141db669dbdc5d2cf66f2b8bfd63435bfefd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4370d59550d6847b39730631865e336845d2023013f0d95de7ad8ab7904e3838"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1bef4f7921d091f59aba08bbf92972f626ec9f218454f2a0703395df0ec9b43"
    sha256 cellar: :any_skip_relocation, ventura:        "850af7ac3d66c46adbe60538fde2c12e758e36f61bcd182f82a8a763fd44e249"
    sha256 cellar: :any_skip_relocation, monterey:       "9ec3f783d35831864e9172a6277868f54958d027525316207d6865b747b6b4d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0532d34a195e12fdcffe407c51029f1dddd8938dbce9964af216d1b800fa4356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "123e4e200d2db51328b5876f72b4367760b5eeb0fa1e88febb55676688d38727"
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
