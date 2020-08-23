class Gnirehtet < Formula
  desc "Reverse tethering tool for Android"
  homepage "https://github.com/Genymobile/gnirehtet"
  url "https://github.com/Genymobile/gnirehtet/archive/v2.5.tar.gz"
  sha256 "2b55b56e1b21d1b609a0899fe85d1f311120bb12b04761ec586187338daf6ec5"
  license "Apache-2.0"
  revision 1
  head "https://github.com/Genymobile/gnirehtet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f65def77cc1708e7a1ae8e85dfe2cbede4717225e8a5c2f7a9f09c8271282f3" => :catalina
    sha256 "7ebc9b16c6d6856be8604388d4ca2bfc9cc2c4ec02e255f1a462be681283c6e8" => :mojave
    sha256 "a57d5039af819db991968751511a63874cd0c20d1d10fe106ef92e83b216eb38" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "socat" => :test

  resource "java_bundle" do
    url "https://github.com/Genymobile/gnirehtet/releases/download/v2.5/gnirehtet-java-v2.5.zip"
    sha256 "c65fc1a35e6b169ab6aa45e695c043e933f6fd650363aea7c2add0ecb0db27ca"
  end

  def install
    resource("java_bundle").stage { libexec.install "gnirehtet.apk" }

    system "cargo", "install", "--locked", "--root", libexec, "--path", "relay-rust"
    mv "#{libexec}/bin/gnirehtet", "#{libexec}/gnirehtet"

    (bin/"gnirehtet").write_env_script("#{libexec}/gnirehtet", GNIREHTET_APK: "#{libexec}/gnirehtet.apk")
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew cask install android-platform-tools
    EOS
  end

  test do
    gnirehtet_err = "#{testpath}/gnirehtet.err"
    gnirehtet_out = "#{testpath}/gnirehtet.out"

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
