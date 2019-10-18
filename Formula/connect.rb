class Connect < Formula
  desc "Provides SOCKS and HTTPS proxy support to SSH"
  homepage "https://bitbucket.org/gotoh/connect/wiki/Home"
  url "https://bitbucket.org/gotoh/connect/get/1.105.tar.gz"
  sha256 "e7c98d31787f93b51c62ee05e0b558cfb577cda8198834a6d5b4d32528bf63ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "a353ddbeceae3a28038be62f2bbbdc54be7f2bd8642c57e33c2cd5f883dcfb3d" => :catalina
    sha256 "9950d137f925a1a64a241235fa355ec0b73238e1d89c9b31cc979ce8ccba3f98" => :mojave
    sha256 "406798ed3fe31bdf93780ea4f33b3be0c14b3d262ff09c3fa11eb6bad509a643" => :high_sierra
    sha256 "20658283a4ed9ee93c6a6faeb2b33d0b3721ababb31068b6d898da5db77b0a68" => :sierra
    sha256 "af244ce650bc1ebd50209b62d98c9780df9ff3b90b2b7496f7b74426f33349a6" => :el_capitan
    sha256 "1285bb995a9eed5ce5198da853bd33ce49c04ac0caa328b651be5d0421e784f4" => :yosemite
    sha256 "4f1dffe41e3164e12fe447c123e17a998cdc936d5dddb7cdc6195fb1b2293fcb" => :mavericks
  end

  def install
    system "make"
    bin.install "connect"
  end

  test do
    system bin/"connect"
  end
end
