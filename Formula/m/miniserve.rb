class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "a4773ae5a6fbc45baf15a5dcb54fd6b7e0151f2fde25c26ddafc0f95b7d26c32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28252a45c5f4bcef63ed849f6b453b57eb18d080b073c0059d1eb0cc87ccda86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03e59a9ce1952634eaaab99d44a0839a82d70127d483c5869015f07434d6e954"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e9b4cb352010e7c1be4c96711292de8d69385538ae9a99f4a90913ce63b0c9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "447ada3ce5abd1fe35e88df3fcce5b55929ec54ef65d1aee94057442ec16e041"
    sha256 cellar: :any_skip_relocation, ventura:       "6454230d31354090753d503de1e50a8769ab96528712eafc0fd757c23e2ad11d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2512bebf6ee3e80be335a1530c184ee623bd2f9c435e0ffef2d81901abff42e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6793b37a2d3d20079413a7449531e708e107b35055c96ec73df316602742ee49"
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
      exec bin/"miniserve", bin/"miniserve", "-i", "127.0.0.1", "--port", port.to_s
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
