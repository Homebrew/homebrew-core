class Masscan < Formula
  desc "TCP port scanner, scans entire Internet in under 5 minutes"
  homepage "https://github.com/robertdavidgraham/masscan/"
  url "https://github.com/robertdavidgraham/masscan/archive/1.3.1.tar.gz"
  sha256 "44c303eff8274c689d306b5f21b8b15acf6bf2b2980a2c01698a94ebae2bc166"
  license "AGPL-3.0"
  head "https://github.com/robertdavidgraham/masscan.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bd1e27ecc33563b9d658443216bbd46526db0a4bcae7068293deda858f9077b7" => :big_sur
    sha256 "147e7c46071329d24e43c5cbfc9187f8e098f576510fcf6b43bb2fd7cb637aac" => :arm64_big_sur
    sha256 "ea14dde3b5fe0813ca9737cc0be54e46078ba3de67d701a7249a84bbd34271bf" => :catalina
    sha256 "b0ebd8c0f61bc44267bdda6467f71b4c6b7f363f705e58b30160b7d341ce58f2" => :mojave
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
