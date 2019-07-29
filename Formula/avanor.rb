class Avanor < Formula
  desc "Quick-growing roguelike game with easy ADOM-like UI"
  homepage "https://avanor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avanor/avanor/0.5.8/avanor-0.5.8-src.tar.bz2"
  sha256 "8f55be83d985470b9a5220263fc87d0a0a6e2b60dbbc977c1c49347321379ef3"

  bottle do
    sha256 "ca4aef9b5bceb8f3dddd89f58846f4d9cfbddf2f108a7e8e39d262e92ea9bac4" => :mojave
    sha256 "d99615cac684c32894df532e78452b2542ba857ce69fa58d39e54bcc2fe4ca4a" => :high_sierra
    sha256 "848e96ed26b258042b77a3c2139398b8e6f62722719263c082fb4c6655ffd4bc" => :sierra
    sha256 "a66b436a645cafa77a5bd79d22f314ff2b9331526f5efeaf79d38346647cad66" => :el_capitan
    sha256 "1c12fd7f45993d18b481d3317594083e4bb88f0eecf100d4b5dd4a927c866200" => :yosemite
  end

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
    system "./script.exp"
  end
end
