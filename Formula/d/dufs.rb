class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://github.com/sigoden/dufs/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "62aa2cadd77e1bd9d96c77cbd832a53ffc364301c549001bf8fd9d023cbd8ab1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2623f7700a3913841f199db10539e61d1625feb3cdf7d2559b8492ec170e771"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4a8c894f245955cbe70f070d6d44491116b22597568ed2df8f657604dd0dad1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99b888d76b8b9333829318cb386a9f57dfd6a199cf5fd97ec6bc43eb820b2077"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d90c2920723a064c8d7eecbdabcb120239bfb3957a42582dd5a00e6c8f4498bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fd86ac85b2f189bd2ca6272595cb058a96257593e99ad613efc00f82b38838c"
    sha256 cellar: :any_skip_relocation, ventura:       "8234b27ea41c52056cd4e7b7538f74bec5e9f8de89f85c3c41c9da6de82bf2c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cf91d3356b14a9bee84d2b99b779571bdd49a8f7203530dccc2ddaa656eece5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9555a2f90b0bda4e1c21cfe7a81001f9bc9d93fa1d45a3546faf893dffa1a0e0"
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
