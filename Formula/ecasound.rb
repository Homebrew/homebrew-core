class Ecasound < Formula
  desc "Multitrack-capable audio recorder and effect processor"
  homepage "https://www.eca.cx/ecasound/"
  url "https://ecasound.seul.org/download/ecasound-2.9.1.tar.gz"
  sha256 "39fce8becd84d80620fa3de31fb5223b2b7d4648d36c9c337d3739c2fad0dcf3"

  bottle do
    sha256 "f948edb013b464b984a44dee9a0bd6e8fc9d6e5f1deba13c8d57e668d0b1b92f" => :mojave
    sha256 "cc433f924ea12f9450d064be622a290cab97bdad35e83ed98658335ae61f47c0" => :high_sierra
    sha256 "789fd275a49c7017ee25d1f5e00a802b3c5f2baa5d54db3753c566e04cd335c2" => :sierra
    sha256 "a0bfadb79c1b81c2764290a4cc6e2eae09bae34e4ec54f06e6d4d669bceed331" => :el_capitan
    sha256 "087b99f6242cfb60eaf73b8f79643d3a78ea53dffccddeb2f89757c3835380bd" => :yosemite
    sha256 "e1230a9513d1011c60a51569fa8cee5671dc79867c75c8b548005b5949984a7f" => :mavericks
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-rubyecasound=no
    ]
    system "./configure", *args
    system "make", "install"
  end
end
