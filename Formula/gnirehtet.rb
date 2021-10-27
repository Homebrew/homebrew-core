class Gnirehtet < Formula
  desc "Reverse tethering tool for Android"
  homepage "https://github.com/Genymobile/gnirehtet"
  url "https://github.com/Genymobile/gnirehtet/archive/v2.5.tar.gz"
  sha256 "2b55b56e1b21d1b609a0899fe85d1f311120bb12b04761ec586187338daf6ec5"
  license "Apache-2.0"
  revision 1
  head "https://github.com/Genymobile/gnirehtet.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e895ff323e648db638a97542eeed9d71936f882c36b95e410bd50a7ff272ffd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fd56faf93c88c65df43599e0dda5c7d3044e6b1dee05ef535d6eff42b558684"
    sha256 cellar: :any_skip_relocation, monterey:       "473eea2bf04850ae912eb9813ec172518890d86bf311d3b88119b61d131d2885"
    sha256 cellar: :any_skip_relocation, big_sur:        "c81db3a1b9c0c6ebbe81ebca2ffd111f97d6eda2cff2cb92955cc8c42abcce63"
    sha256 cellar: :any_skip_relocation, catalina:       "6f65def77cc1708e7a1ae8e85dfe2cbede4717225e8a5c2f7a9f09c8271282f3"
    sha256 cellar: :any_skip_relocation, mojave:         "7ebc9b16c6d6856be8604388d4ca2bfc9cc2c4ec02e255f1a462be681283c6e8"
    sha256 cellar: :any_skip_relocation, high_sierra:    "a57d5039af819db991968751511a63874cd0c20d1d10fe106ef92e83b216eb38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94166648cf3a8a072b85eed7436af2bddbcf5c2dfab939cd79590d4ff2b9a9c3"
  end

  depends_on "rust" => :build
  depends_on "socat" => :test

  resource "java_bundle" do
    url "https://github.com/Genymobile/gnirehtet/releases/download/v2.5/gnirehtet-java-v2.5.zip"
    sha256 "c65fc1a35e6b169ab6aa45e695c043e933f6fd650363aea7c2add0ecb0db27ca"
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
