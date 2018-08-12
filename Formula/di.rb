class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://gentoo.com/di/di-4.47.tar.gz"
  sha256 "b5031c1f3b98536eee95fb91634fe700cec5e08a3cf38e14fffc47f969bf8a7e"

  bottle do
    cellar :any_skip_relocation
    sha256 "81c4864d599c750853763af46e78d9cc63f7cd57d892e9609e80eecd6c815eac" => :high_sierra
    sha256 "cd3618e1d20bbacf19690dd9b851399714e94bd89af4a9b4e22de6dd38ce39d1" => :sierra
    sha256 "6763e3cfb49aba34aab28df7a0deec27fa9603463220f4b2d4750530176ba6bf" => :el_capitan
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
