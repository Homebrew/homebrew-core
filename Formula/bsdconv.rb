class Bsdconv < Formula
  desc "Charset/encoding converter library"
  homepage "https://github.com/buganini/bsdconv"
  url "https://github.com/buganini/bsdconv/archive/11.4.tar.gz"
  sha256 "61919c8a7bae973794ef8b13c7e105ae4570cd832851570ca76a47c731cade6c"
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
    output = pipe_output("#{bin}/bsdconv BIG5:UTF-8", "\263\134\273\134")
    output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_equal "許蓋", output
  end
end
