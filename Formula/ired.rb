class Ired < Formula
  desc "Minimalistic hexadecimal editor designed to be used in scripts."
  homepage "https://github.com/radare/ired"
  url "https://github.com/radare/ired/archive/0.6.tar.gz"
  sha256 "c15d37b96b1a25c44435d824bd7ef1f9aea9dc191be14c78b689d3156312d58a"

  bottle do
    cellar :any_skip_relocation
    sha256 "07b729be0f1b5218111d26df84352e1985a0a558a44f32724055953a7fe8e4bd" => :sierra
    sha256 "7d02292ccb5d3f0cf283c732428259be1d1a12c934cae9e20b1a5d64f7ca473a" => :el_capitan
    sha256 "8f3ea6c227b0a939a3c9cd65528439d59bbd8cb493c5d5f87de64f54173fa926" => :yosemite
    sha256 "17661990a22e84dce84fa684d096f0082925bb5e05d04807704bc6403904a558" => :mavericks
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    input = <<-EOS.undent
      w"hello wurld"
      s+7
      r-4
      w"orld"
      q
    EOS
    pipe_output("#{bin}/ired test.text", input)
    assert_equal "hello world", (testpath/"test.text").read.chomp
  end
end
