class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://gentoo.com/di/di-4.46.tar.gz"
  sha256 "3cc77280618d5e7b61eeedd3f25bb8521a6de5420793d73e217ce2c83d8e5333"

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
