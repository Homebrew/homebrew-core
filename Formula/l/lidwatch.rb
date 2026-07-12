class Lidwatch < Formula
  desc "Sleeps a MacBook when its lid closes while docked"
  homepage "https://github.com/KristijanKocev/noclamshell/tree/master/LidWatch"
  url "https://github.com/KristijanKocev/noclamshell/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "54f4dd255055f62c7c89e025e06c222c7ff984e158e1ef72e0332653c8e13a76"
  license "MIT"

  depends_on :macos

  def install
    cd "LidWatch" do
      system "swift", "build", "--disable-sandbox", "-c", "release"
      bin.install ".build/release/LidWatch"
    end
  end

  service do
    run opt_bin/"LidWatch"
    keep_alive true
    log_path var/"log/lidwatch.log"
    error_log_path var/"log/lidwatch.error.log"
  end

  test do
    assert_predicate bin/"LidWatch", :executable?
  end
end
