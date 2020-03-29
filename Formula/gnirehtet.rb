class Gnirehtet < Formula
  desc "Reverse tethering tool for Android"
  homepage "https://github.com/Genymobile/gnirehtet"
  url "https://github.com/Genymobile/gnirehtet/archive/v2.4.tar.gz"
  sha256 "5ff179fca58e85473e737680a72aeb84c710082283bfe9cce4b044b3c2436c4d"
  head "https://github.com/Genymobile/gnirehtet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f2c4797209bc261df8b2b9ba75d2719070c1c3e587c392d941aac7b18e9da8e" => :catalina
    sha256 "879106aecceb430220e20e3224e906cb2cbe1fdf92febed03c6f319fb668592d" => :mojave
    sha256 "86843aab81fac7df1b3fe9c92c47ea6be7367fecefa90398dd2a9d322160455a" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "socat" => :test

  resource "java_bundle" do
    url "https://github.com/Genymobile/gnirehtet/releases/download/v2.4/gnirehtet-java-v2.4.zip"
    sha256 "10b6cca49a76231fbf8ac3428cf95e9f1c193c4f47abe2b8e2aa16746eb8cc21"
  end

  def install
    resource("java_bundle").stage { libexec.install "gnirehtet.apk" }

    system "cargo", "install", "--locked", "--root", libexec, "--path", "relay-rust"
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
