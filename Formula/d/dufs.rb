class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://github.com/sigoden/dufs/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "76439a01c142d6a378912930de4b74821aa2fef54ccfb7dbb00d6ea3b1a0ab4c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ac3566fe5294fe2426e911b28acf6daefac058dc8c0d94e50e902b55323c9d45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6429c8756124168ff779a3fb1ce09ada5fb25e02374ab7b168555763a4b971a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "341a66c050fb0af6a9afff679f5a6e65bbb6d6d5c16199f8d925c80330069a64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e07983bebda8931266dce4c3e23153d22c8d8fe3cd5409425bdd2d7481b726d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "679ca39d82ad40dbb24376f17746ed7ba8e2e72b3262b5b6d948080eff91dae8"
    sha256 cellar: :any_skip_relocation, ventura:        "db19c77860c925734e58f5cf06d6640c76f2fe20464c380b1a873af813656aaa"
    sha256 cellar: :any_skip_relocation, monterey:       "3ae3007836b1297ec00bfcbb8bb31afb54e9d2f9e28454e04bd482788a629c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "379ad8a7c76a0775f5f17dea369a746d2f67e74248d3595234ce7ebb834399f2"
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
