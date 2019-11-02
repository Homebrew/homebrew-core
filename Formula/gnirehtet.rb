class Gnirehtet < Formula
  desc "Reverse tethering tool for Android"
  homepage "https://github.com/Genymobile/gnirehtet"
  url "https://github.com/Genymobile/gnirehtet/archive/v2.3.tar.gz"
  sha256 "bb2cea28975071b8bdf7bb5dc9536e8119eb0ab113e911cdef7b057bb1ad2582"
  head "https://github.com/Genymobile/gnirehtet.git"

  depends_on "rust" => :build
  depends_on "socat" => :test

  resource "java_bundle" do
    url "https://github.com/Genymobile/gnirehtet/releases/download/v2.3/gnirehtet-java-v2.3.zip"
    sha256 "93d1d46ee566376596f033832626dd5e89e76c91f2c46d2383735937b7d3b8b0"
  end

  def install
    resource("java_bundle").stage { libexec.install "gnirehtet.apk" }

    system "cargo", "install", "--root", libexec, "--path", "relay-rust"
    mv "#{libexec}/bin/gnirehtet", "#{libexec}/gnirehtet"

    (bin/"gnirehtet").write <<~EOS
      #!/bin/bash
      if [[ "$1" == "install" ]]; then
        shift
        echo "Installing #{libexec}/gnirehtet.apk"
        adb install -r #{libexec}/gnirehtet.apk
      else
        #{libexec}/gnirehtet $*
      fi
    EOS
  end

  def caveats; <<~EOS
    At runtime, adb must be accessible from your PATH.

    You can install adb from Homebrew Cask:
      brew cask install android-platform-tools
  EOS
  end

  test do
    gnirehtet_err = "#{testpath}/gnirehtet.err"
    gnirehtet_out = "#{testpath}/gnirehtet.out"

    begin
      child_pid = fork do
        Process.setsid
        $stdout.reopen(gnirehtet_out, "w")
        $stderr.reopen(gnirehtet_err, "w")
        exec bin/"gnirehtet", "relay"
      end
      sleep 3
      system "socat", "-T", "1", "-", "TCP4:127.0.0.1:31416"
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
