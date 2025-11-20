class Avanor < Formula
  desc "Quick-growing roguelike game with easy ADOM-like UI"
  homepage "https://avanor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/avanor/avanor/0.5.8/avanor-0.5.8-src.tar.bz2"
  sha256 "8f55be83d985470b9a5220263fc87d0a0a6e2b60dbbc977c1c49347321379ef3"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "f4e7392f6932b4478f15b384de5435734302d9758907fac70bb02d70e8307ea6"
    sha256 arm64_sequoia:  "88abecffbb226843739fc147a93b4ba8d7feeb105f4ae7f3580ceb719c16ce8f"
    sha256 arm64_sonoma:   "f230abf456ef3e8f748a444f6c4909ae3d94553e6fc7dee79a871d1b7639e9a7"
    sha256 arm64_ventura:  "ccc57d4f9e6be0a45d01a7498cd8f4503810d6f754847ca561e0404f705ad5b7"
    sha256 arm64_monterey: "44a7864d851ed2f13f69d2db72dab4f8622dd7e52e03933f54c4f1c625deb6e6"
    sha256 arm64_big_sur:  "6c2ae364f9e7c7ce1f3876a4ce9acb53489e9a17221646f004895ccd239e4646"
    sha256 sonoma:         "4bad762a39191e5bb9fa549ad6e9357c68031a1a0f0603585eb4d339956ac052"
    sha256 ventura:        "068723dfb7c9ce0a1c77337ed71fa3966a9bde3abd5af431d9fe80bbc6eebb5d"
    sha256 monterey:       "31f93f42adc5936fa370279095f656b270e0ffb3fe79f3fa163cab67d6fa3bb7"
    sha256 big_sur:        "fe8fbd3aed29fc9c50753000036d9c13b5e8732f687d71b061d954e83517d403"
    sha256 catalina:       "ecaf9be2ed4f7fac2f5cff16be121214bbbfd44477a5f3f5287ce26da94fed3e"
    sha256 arm64_linux:    "39d71fa50daeab0033fb05cbc656d28654effd5c1d650b8e4cbb339ef96004ec"
    sha256 x86_64_linux:   "99ac78a20ffc5cccb1a0b5617c9977501a41edb8823663ee4656d177fad7ed09"
  end

  uses_from_macos "ncurses"

  # Upstream fix for clang: https://sourceforge.net/p/avanor/code/133/
  patch :p0 do
    url "https://gist.githubusercontent.com/mistydemeo/64f47233ee64d55cb7d5/raw/c1847d7e3a134e6109ad30ce1968919dd962e727/avanor-clang.diff"
    sha256 "2d24ce7b71eb7b20485d841aabffa55b25b9074f9a5dd83aee33b7695ba9d75c"
  end

  def install
    system "make", "DATA_DIR=#{pkgshare}/", "CC=#{ENV.cxx}", "LD=#{ENV.cxx}"
    bin.install "avanor"
    pkgshare.install "manual"
  end

  test do
    ENV["TERM"] = "xterm"
    assert_match "T h e  L a n d  o f  M y s t e r y", pipe_output(bin/"avanor", "\e", 0)
  end
end
