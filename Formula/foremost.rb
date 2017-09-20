class Foremost < Formula
  desc "Console program to recover files based on their headers and footers"
  homepage "https://foremost.sourceforge.io/"
  url "https://foremost.sourceforge.io/pkg/foremost-1.5.7.tar.gz"
  sha256 "502054ef212e3d90b292e99c7f7ac91f89f024720cd5a7e7680c3d1901ef5f34"

  bottle do
    rebuild 1
    sha256 "1fec9cd62de192dcbd5217cfa2c6c1c1ca056afa85a434114748171bf740ed96" => :sierra
    sha256 "73f4f781edd9621d498238d77536dda5fbfa60dbb613bd7f15bb31d72699c986" => :el_capitan
  end

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr/", "#{prefix}/"
      s.change_make_var! "RAW_CC", ENV.cc
      s.change_make_var! "RAW_FLAGS", ENV.cflags
    end

    system "make", "mac"

    bin.install "foremost"
    man8.install "foremost.8.gz"
    etc.install "foremost.conf" => "foremost.conf.default"
  end
end
