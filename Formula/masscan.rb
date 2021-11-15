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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba6a70814b1e311a2b817fd79e7d9a70657ceb74be1691215802a4470ca3be87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b99bf991011be4ee7d76fe43aa000159f0665b888a0cbc7c4d528d102a3daa67"
    sha256 cellar: :any_skip_relocation, monterey:       "80601cda78b927edb63ae9e0a6b15bb9aa7d621b793d7a6cfa094a0465e66070"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d21dd16d333a573d7146d13c31dea07df5c72fcfe137af338e6f7722b393dbe"
    sha256 cellar: :any_skip_relocation, catalina:       "a77ea3fd36501d9a0d0398e585f1d30fd64163ca378e6af9660601a10e1ddce3"
    sha256 cellar: :any_skip_relocation, mojave:         "19def74a8381541e80c530a5f0599bc92f067ac3e211ecc173afbbb0aee72752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9fe1b11c5d18f102a83a6497972a7e49298f856adc260f83ac7a3d406824887"
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
