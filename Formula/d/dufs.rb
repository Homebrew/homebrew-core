class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://github.com/sigoden/dufs/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "8c0549678a4954a498e0f1f99fe4beec2acd3cb0084fc611cf20431313b05033"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09d12364717ce43d02181db124d3eb1cf5c366b417190a6002bc14acf96c0ae4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28999d5b0e1dc24bdaa4c38ff8cf8642ad531cfcd43b31a82a3fe4c23146037d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4475dc148bdc74b27395805ee113bbda358c4ecde493a4c6efb1bb21eb72632e"
    sha256 cellar: :any_skip_relocation, sonoma:         "733ef95274ffe10c44a790765bf68ee0d79f6b4181c16b3213293f765d90e38d"
    sha256 cellar: :any_skip_relocation, ventura:        "709da7d0b1d757fcf4939716ccc30b072316766ff7d9d8c3087b28ac1b9663aa"
    sha256 cellar: :any_skip_relocation, monterey:       "407e3e17eb39494141f79ff647fc6af149486e1db3618b484d6356a7b7b6a98a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de418b9b6c1ce412cc721e06987f3080cda7a06be44342f099e57bf65b9fa43d"
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
