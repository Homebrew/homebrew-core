class Gnirehtet < Formula
  desc "Reverse tethering tool for Android"
  homepage "https://github.com/Genymobile/gnirehtet"
  url "https://github.com/Genymobile/gnirehtet/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "0d41361b9ac8b3b7fa4f4a0aff933472a72886556bd3fc4659be299b546274e6"
  license "Apache-2.0"
  head "https://github.com/Genymobile/gnirehtet.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3f10f0ff297c3164e291d2c42c572d826515052a4f764688ee9d4a93ce8c8d85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5f0e5fbe1add7c5624e860f5301ff482236f9730fd5d9fa3d563a961bc54e22b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab10ed478b79d0bd8877a477d1f8bdecf2ca129755cbc3a8270d99e11d911c97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5b5df70aa9d156188c4a83b6817064309e53eccaca64d4c21fc6e3dd17b026c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc70af0b7c95793dc71b60f38a8ac0eff9c24956f3b9424468117c2cc8d9c8b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "011242189fda65be5d4be17acd3bcd470e3a4376fc180292c504ff5c54f939b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dd2936239d05ae4090b31fdd5f5d926af12a0f7122cd5fb983bf7a993a94fdb"
    sha256 cellar: :any_skip_relocation, ventura:        "16e2b20622495234ad41bd99233c72288221e721b071d37984355c1f291e9377"
    sha256 cellar: :any_skip_relocation, monterey:       "984d3dfb57b8b4e76c9df974349af5f82d5e1b208ca4fdb87d1fc8f695ee6804"
    sha256 cellar: :any_skip_relocation, big_sur:        "2724057e42986f088b033462ab4c8bc058a1b16bc0deb6209904e0eb04a6c4e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4f8b6b690e847b806898b5f6b35340362d176eae643ec7df69bc1f11c94fa3b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c3ffedc36f982c44315b5970a26ccd45fe13db36d3daf8c16510157f87d565d"
  end

  depends_on "rust" => :build
  depends_on "socat" => :test

  resource "java_bundle" do
    url "https://github.com/Genymobile/gnirehtet/releases/download/v2.5.1/gnirehtet-java-v2.5.1.zip"
    sha256 "816748078fa6a304600a294a13338a06ac778bcc0e57b62d88328c7968ad2d3a"
  end

  def install
    resource("java_bundle").stage { libexec.install "gnirehtet.apk" }

    system "cargo", "install", *std_cargo_args(root: libexec, path: "relay-rust")
    mv "#{libexec}/bin/gnirehtet", "#{libexec}/gnirehtet"

    (bin/"gnirehtet").write_env_script("#{libexec}/gnirehtet", GNIREHTET_APK: "#{libexec}/gnirehtet.apk")
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    gnirehtet_err = testpath/"gnirehtet.err"
    gnirehtet_out = testpath/"gnirehtet.out"

    port = free_port
    begin
      child_pid = fork do
        Process.setsid
        $stdout.reopen(gnirehtet_out, "w")
        $stderr.reopen(gnirehtet_err, "w")
        exec bin/"gnirehtet", "relay", "-p", port.to_s
      end
      sleep 3
      system "socat", "-T", "1", "-", "TCP4:127.0.0.1:#{port}"
    ensure
      pgid = Process.getpgid(child_pid)
      Process.kill("HUP", -pgid)
      Process.detach(pgid)
    end

    assert_empty File.readlines(gnirehtet_err)

    output = File.readlines(gnirehtet_out)
    assert output.any? { |l| l["TunnelServer: Client #0 connected"] }
    assert output.any? { |l| l["TunnelServer: Client #0 disconnected"] }
  end
end
