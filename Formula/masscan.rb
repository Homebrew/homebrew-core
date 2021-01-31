class Masscan < Formula
  desc "TCP port scanner, scans entire Internet in under 5 minutes"
  homepage "https://github.com/robertdavidgraham/masscan/"
  url "https://github.com/robertdavidgraham/masscan/archive/1.3.2.tar.gz"
  sha256 "0363e82c07e6ceee68a2da48acd0b2807391ead9a396cf9c70b53a2a901e3d5f"
  license "AGPL-3.0-only"
  head "https://github.com/robertdavidgraham/masscan.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "612d8beacadb4af14a1dd776b422d224d3430bd6bfae2c7b7e459184e53bd50e" => :big_sur
    sha256 "94df6861a365e06e6c8670f494263ad8a7b99ee7dfd52640afffe9caa0b29a74" => :arm64_big_sur
    sha256 "d25f5a0ebdce09e1f2adb6a30f0b3fb2510133142707e534880d1883f41a3de1" => :catalina
    sha256 "5502310faef46572223ac81702ed48327bbe93778bc2031aaef4ff99b4a0d185" => :mojave
  end

  def install
    # Fix `dyld: lazy symbol binding failed: Symbol not found: _clock_gettime`
    # Reported 8 July 2017: https://github.com/robertdavidgraham/masscan/issues/284
    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
      inreplace "src/pixie-timer.c", "#elif defined(CLOCK_MONOTONIC)", "#elif defined(NOT_A_MACRO)"
    end

    system "make"
    bin.install "bin/masscan"
  end

  test do
    assert_match "ports =", shell_output("#{bin}/masscan --echo")
  end
end
