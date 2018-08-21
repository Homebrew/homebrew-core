class Fsh < Formula
  desc "Provides remote command execution"
  homepage "https://www.lysator.liu.se/fsh/"
  url "https://www.lysator.liu.se/fsh/fsh-1.2.tar.gz"
  sha256 "9600882648966272c264cf3f1c41c11c91e704f473af43d8d4e0ac5850298826"

  bottle do
    cellar :any_skip_relocation
    sha256 "1600e94eda45d61acf6980d5483a7a225fd431e545b817a493c0b38b359d8cb4" => :mojave
    sha256 "71abf994ecf91d4675daef2c6604e6d414d9e33c2b66b5dc6240ee44f888f442" => :high_sierra
    sha256 "13a7134ef9d20899642d8dd96e77603d74573cf3a0e1ef5063f6eefc856dbd37" => :sierra
    sha256 "cec52eb07f9db79b15ff5907f30363bbb538c01b7c4eb7ae8634e7ce17eb5431" => :el_capitan
    sha256 "8a49ad906b045a293259c199fd5d1737894099c487b1bfc83fb60d18acf065ac" => :yosemite
    sha256 "ed852d51f5a0a4024d4a195c9cffd604758a11a115620a3da0975b541c912770" => :mavericks
    sha256 "2ddff507244ca8dc352c39d5372f13cfe42c04e19d7b1d4832ecafb58fc8d00b" => :mountain_lion
  end

  def install
    # FCNTL was deprecated and needs to be changed to fcntl
    inreplace "fshcompat.py", "FCNTL", "fcntl"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}"
    system "make", "install"
  end

  test do
    system "#{bin}/fsh", "-V"
  end
end
