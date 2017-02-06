class Avanor < Formula
  desc "Quick-growing roguelike game with easy ADOM-like UI"
  homepage "http://avanor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/avanor/avanor/0.5.8/avanor-0.5.8-src.tar.bz2"
  sha256 "8f55be83d985470b9a5220263fc87d0a0a6e2b60dbbc977c1c49347321379ef3"

  bottle do
    sha256 "89c8215f9e670819e065820a3fd59dee56c7e59f9e304f799f2b319db372f998" => :el_capitan
    sha256 "0c8cce6920444c2b7d6ea524bc9881f2e19c6ced735bb4f833cb6e04c49c5ffc" => :yosemite
    sha256 "0899dfe6dbc824bdf5b589020063c711c51fde9a6cca87048ec352779c2cbcf1" => :mavericks
  end

  # Upstream fix for clang: http://sourceforge.net/p/avanor/code/133/
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
    script.write <<-EOS.undent
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
