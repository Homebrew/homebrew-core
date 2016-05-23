class Genders < Formula
  desc "Static cluster configuration database for cluster management"
  homepage "https://computing.llnl.gov/linux/genders.html"
  url "https://downloads.sourceforge.net/project/genders/genders/1.22-1/genders-1.22.tar.gz"
  sha256 "0ff292825a29201106239c4d47d9ce4c6bda3f51c78c0463eb2634ecc337b774"

  bottle do
    cellar :any
    sha256 "f079371f0806c6cca9cb8494636dc20ff07b67ac6e236df955a9e4955389e999" => :el_capitan
    sha256 "116ea2ec83b058a2f22f379c769b09af58548fae4dbf72129e7c25a0fd030bb7" => :yosemite
    sha256 "a10c47616878f37541875643e1bc54e50b95d839f72277041ffbc269bce75c17" => :mavericks
  end

  option "with-non-shortened-hostnames", "Allow non shortened hostnames that can include dots e.g. www.google.com"

  def install
    args = ["--prefix=#{prefix}"]

    args << "--with-java-extensions=no"

    args << "--with-non-shortened-hostnames" if build.with? "non-shortened-hostnames"

    system "./configure", *args
    system "make", "install"
  end
end
