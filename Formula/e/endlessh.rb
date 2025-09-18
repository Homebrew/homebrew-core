class Endlessh < Formula
  desc "SSH tarpit that slowly sends an endless banner"
  homepage "https://github.com/skeeto/endlessh"
  url "https://github.com/skeeto/endlessh/archive/refs/tags/1.1.tar.gz"
  sha256 "786cea9e2c8e0a37d3d4ecd984ca4a0ae0b2d6e2b8da37e3cdbb9d49ccdecbf0"
  license "Unlicense"
  head "https://github.com/skeeto/endlessh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4202f6d8cafa9fe5bba76475634b730a4b8235374ed727dccc887fa31ca9ec1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56f067a5697921c5bf68ac5d3dce1062810e0a9f065f27804161f84200848ed8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad8d82e04aafeb852b26afeafbbbfb7f9028ec57253f735574064a5691941167"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "527c4f3907171823be211401208e6545a3d0eee7d51000364e4d2a74ee75907a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0acf3cfa595c82accf520069b701e2057c3a646d53521cff6f4f29f80cb732d9"
    sha256 cellar: :any_skip_relocation, ventura:       "53b1c6fab6fc6c3cc9f1480326d27f7d0c49ab7c2f97ee35669fec08d4bd6c4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d8deb876ef8f365e1dfc727fa1d16cc201f409d5de3f763c0169e33bc3c4b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e57658ab99509383d7a2c7ec8ee64de0ca64c8a6a14535fcedb62bf08473698"
  end

  uses_from_macos "netcat" => :test

  def install
    inreplace "endlessh.c", "/etc/endlessh/", "#{pkgetc}/"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    port = free_port
    pid = spawn(bin/"endlessh", "-p", port.to_s)

    sleep 5

    system "nc", "-z", "localhost", port
  ensure
    Process.kill "HUP", pid
  end
end
