class Avanor < Formula
  desc "Quick-growing roguelike game with easy ADOM-like UI"
  homepage "https://avanor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avanor/avanor/0.5.8/avanor-0.5.8-src.tar.bz2"
  sha256 "8f55be83d985470b9a5220263fc87d0a0a6e2b60dbbc977c1c49347321379ef3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "44a7864d851ed2f13f69d2db72dab4f8622dd7e52e03933f54c4f1c625deb6e6"
    sha256 arm64_big_sur:  "6c2ae364f9e7c7ce1f3876a4ce9acb53489e9a17221646f004895ccd239e4646"
    sha256 monterey:       "31f93f42adc5936fa370279095f656b270e0ffb3fe79f3fa163cab67d6fa3bb7"
    sha256 big_sur:        "fe8fbd3aed29fc9c50753000036d9c13b5e8732f687d71b061d954e83517d403"
    sha256 catalina:       "ecaf9be2ed4f7fac2f5cff16be121214bbbfd44477a5f3f5287ce26da94fed3e"
    sha256 mojave:         "ca4aef9b5bceb8f3dddd89f58846f4d9cfbddf2f108a7e8e39d262e92ea9bac4"
    sha256 high_sierra:    "d99615cac684c32894df532e78452b2542ba857ce69fa58d39e54bcc2fe4ca4a"
    sha256 sierra:         "848e96ed26b258042b77a3c2139398b8e6f62722719263c082fb4c6655ffd4bc"
    sha256 el_capitan:     "a66b436a645cafa77a5bd79d22f314ff2b9331526f5efeaf79d38346647cad66"
    sha256 yosemite:       "1c12fd7f45993d18b481d3317594083e4bb88f0eecf100d4b5dd4a927c866200"
    sha256 x86_64_linux:   "99ac78a20ffc5cccb1a0b5617c9977501a41edb8823663ee4656d177fad7ed09"
  end

  uses_from_macos "expect" => :test
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
    script = (testpath/"script.exp")
    script.write <<~EOS
      #!/usr/bin/expect -f
      set timeout 10
      spawn avanor
      send -- "\e"
      expect eof
    EOS
    script.chmod 0700
    system "expect", "-f", "script.exp"
  end
end
