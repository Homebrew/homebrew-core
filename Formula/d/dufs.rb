class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://github.com/sigoden/dufs/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "4ba3b90486336efc4e592bcf15f14d4e3b6ac7b3b1bf8770815b8c43975d8b01"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9907f1078c8ae4f2a52d038eef8ce547ac8cb14d88aced1ae385b562322c717"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "362bbbbe8f036f15d480ef45c944ce97cbe86d9e9b739d2403e9984df7106e6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b5f5323b754d091c8c15573339a9e0ac241eb30a6e1225fe737e9e41cdede6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "dade66c1045bd01e2725a36df9f95b71c2d4035a522bc258ecd9a10069dc0d45"
    sha256 cellar: :any_skip_relocation, ventura:       "ff3b995c743d161810b2d11544feb09771673ad5696ef712413f2ede68ac88c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8efae26008554d3f4fb18d63eaf80b94fff7403fb7e0f148668163527ee265ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf38795658e47257cee21c8d5ee8116fb9241b2638c75d17d03adee7b31b6b72"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dufs", "--completions")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"dufs", bin.to_s, "-b", "127.0.0.1", "--port", port.to_s
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
