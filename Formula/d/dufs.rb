class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://github.com/sigoden/dufs/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "e5bb926107736802bfd3be6937482dd3daf396a5c481fed714de542055286ebc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8809a44c8faee498c2c02f8a12c6fbf0a4d9059505baec2f4e6e16fa09c8063a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b082b2be9df85031227cf41755f732de8f77d8e718334f5d7291542ef56fd074"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e09eb3094f85d9d6ae7e5ab490e72415c96fc666446dcff36d577c4166f1f0c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d44260fdeedd24b497e846259dfae15ca4266b09b4e40c6f90bc2e41c23a51d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1958938715233820f40ba53132fffd9a130c3dcbbb69cb082147891fd9c3f061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de0e44808f99690325dc887515c931ee34e680a8d2d5655eb2f4187e48e189d8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dufs", "--completions")
  end

  test do
    port = free_port
    pid = spawn bin/"dufs", bin.to_s, "-b", "127.0.0.1", "--port", port.to_s

    begin
      sleep 2
      read = (bin/"dufs").read
      assert_equal read, shell_output("curl localhost:#{port}/dufs")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
