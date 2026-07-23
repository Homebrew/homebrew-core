class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "8ae108c161f2ed740f8c4b4dfd0a80805adcbaf7a05a6128f2b4d8f5093f5490"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29cd82cffcde691ad0e8faae29aacaea87345becfa60781208d9d10f511e163e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58b8e8d1cdbe0c34560eee97534ee2c2d618c87721935008054f33856adfaa55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fff25517959d6cb7afccb61b36f37c1c2b691a8b5868ebfa48e6d3da83929d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b984fec4e5919fa601856ed2904ea79f84a43ac272aec7fbd8332bac17ff6049"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f70bb0f5bfd39e8026b4ca2b3ec3b26b3739ae452f12310521551aaf8c12f751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49b74f86fd6a0c30c321459845038c6c3cf6e29cec2c23fb3892e49d3e3b1a22"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"miniserve", "--print-completions")
    (man1/"miniserve.1").write Utils.safe_popen_read(bin/"miniserve", "--print-manpage")
  end

  test do
    port = free_port
    pid = spawn bin/"miniserve", bin/"miniserve", "-i", "127.0.0.1", "--port", port.to_s

    begin
      sleep 2
      read = (bin/"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
