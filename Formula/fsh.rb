class Fsh < Formula
  desc "Provides remote command execution"
  homepage "https://www.lysator.liu.se/fsh/"
  url "https://www.lysator.liu.se/fsh/fsh-1.2.tar.gz"
  sha256 "9600882648966272c264cf3f1c41c11c91e704f473af43d8d4e0ac5850298826"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2814ac8d488659be42929df4fcbdcd3c8755d24fe990034c3125d3b9c61c8ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b68fa920622faedc3241756ed4b5b3498d58a8ff8cb2a236fee0eb7ebc7a1883"
    sha256 cellar: :any_skip_relocation, monterey:       "96578ad9fbc26994866bfd40006a434f987df88f99bcc435e192f0e74b9cf3c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "64ff82df619631ff9e4642c5fc5c27d1d1d94da82f36c2a0492090489278a957"
    sha256 cellar: :any_skip_relocation, catalina:       "d99d2e8e357b91134de9b7a47d8995ff18382ffb2ee15eb4800b2d9872294ba3"
    sha256 cellar: :any_skip_relocation, mojave:         "1600e94eda45d61acf6980d5483a7a225fd431e545b817a493c0b38b359d8cb4"
    sha256 cellar: :any_skip_relocation, high_sierra:    "71abf994ecf91d4675daef2c6604e6d414d9e33c2b66b5dc6240ee44f888f442"
    sha256 cellar: :any_skip_relocation, sierra:         "13a7134ef9d20899642d8dd96e77603d74573cf3a0e1ef5063f6eefc856dbd37"
    sha256 cellar: :any_skip_relocation, el_capitan:     "cec52eb07f9db79b15ff5907f30363bbb538c01b7c4eb7ae8634e7ce17eb5431"
    sha256 cellar: :any_skip_relocation, yosemite:       "8a49ad906b045a293259c199fd5d1737894099c487b1bfc83fb60d18acf065ac"
  end

  # Requires Python 2.
  # https://github.com/Homebrew/homebrew-core/issues/93940
  deprecate! date: "2022-03-10", because: :unsupported

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
