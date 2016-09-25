class Ecasound < Formula
  desc "Multitrack-capable audio recorder and effect processor"
  homepage "http://www.eca.cx/ecasound/"
  url "http://ecasound.seul.org/download/ecasound-2.9.1.tar.gz"
  sha256 "39fce8becd84d80620fa3de31fb5223b2b7d4648d36c9c337d3739c2fad0dcf3"

  bottle do
    sha256 "789fd275a49c7017ee25d1f5e00a802b3c5f2baa5d54db3753c566e04cd335c2" => :sierra
    sha256 "a0bfadb79c1b81c2764290a4cc6e2eae09bae34e4ec54f06e6d4d669bceed331" => :el_capitan
    sha256 "087b99f6242cfb60eaf73b8f79643d3a78ea53dffccddeb2f89757c3835380bd" => :yosemite
    sha256 "e1230a9513d1011c60a51569fa8cee5671dc79867c75c8b548005b5949984a7f" => :mavericks
  end

  option "with-ruby", "Compile with ruby support"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << ("--enable-rubyecasound=" + ((build.with? "ruby") ? "yes" : "no"))
    system "./configure", *args
    system "make", "install"
  end
end
