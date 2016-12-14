class Chkrootkit < Formula
  desc "Rootkit detector"
  homepage "http://www.chkrootkit.org/"
  url "ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit-0.51.tar.gz"
  mirror "https://fossies.org/linux/misc/chkrootkit-0.51.tar.gz"
  sha256 "f66166f5cbff39d9079fc0cac303fdf9e6b4a65a987110e947de94803c5c1378"

  bottle do
    cellar :any_skip_relocation
    sha256 "687f4b80b7c7a82af8cb3c3079e848b9538600b990e4b57acee2bab5efc1fdeb" => :sierra
    sha256 "d631f10284719bd507c6e08bfadc68507adda611d1488dfe6f59f2cdf3b7d1e9" => :el_capitan
    sha256 "e55c78bfac4b081cef6b51e46cf3ff7fed13b4150f8772535fa401e83bcfe213" => :yosemite
    sha256 "db4476a3cfc7d10f9991628c95068784c702662bc0be79b124fd775c56c65ecf" => :mavericks
    sha256 "8aa44d8d76a8d6ddbc27adac04e64e3120c4599b2d617ff0fa82d15f8229957b" => :mountain_lion
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}",
                   "STATIC=", "sense", "all"

    bin.install Dir[buildpath/"*"].select { |f| File.executable? f }
    doc.install %w[README README.chklastlog README.chkwtmp]
  end

  test do
    assert_equal "chkrootkit version #{version}",
                 shell_output("#{bin}/chkrootkit -V 2>&1", 1).strip
  end
end
