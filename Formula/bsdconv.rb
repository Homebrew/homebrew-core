class Bsdconv < Formula
  desc "Charset/encoding converter library"
  homepage "https://github.com/buganini/bsdconv"
  url "https://github.com/buganini/bsdconv/archive/11.3.1.tar.gz"
  sha256 "b0656011fd40ec440e9966bba44d330a6213fdd198c487c87bc61869ef7fea9e"

  head "https://github.com/buganini/bsdconv.git"

  bottle do
    sha256 "1a38dd1feb798a4d6c9a236e423c2731c4e69b28f957e261450fdf9df856cf0b" => :el_capitan
    sha256 "8644a19627371e56d1011ffa6a9ea1ce95dbfeedbca5d1d0280877acc2003fdc" => :yosemite
    sha256 "97b9f275e05512e83dcbbb07720fe5cadaa4dd1318faf95854dcf2c92c861b45" => :mavericks
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/bsdconv", "big5:utf-8") do |stdin, stdout, _|
      stdin.write("\263\134\245\134\273\134")
      stdin.close
      result = stdout.read
      result.force_encoding(Encoding::UTF_8) if result.respond_to?(:force_encoding)
      assert_equal "許功蓋", result
    end
  end
end
