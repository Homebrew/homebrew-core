class Foremost < Formula
  desc "Console program to recover files based on their headers and footers"
  homepage "http://foremost.sourceforge.net/"
  url "http://foremost.sourceforge.net/pkg/foremost-1.5.7.tar.gz"
  sha256 "502054ef212e3d90b292e99c7f7ac91f89f024720cd5a7e7680c3d1901ef5f34"

  bottle do
    cellar :any_skip_relocation
    sha256 "35b0f207c144db1493182ea448b4458b179971b024b00fd1d7611173b5656cad" => :sierra
    sha256 "153967284382e4a8206a627ac415c7bf39732279c3e1dc1bf377edcf0f2939b2" => :el_capitan
    sha256 "7b793ac9f697b1aa9da79a04b7394ce93909149dae5f2817c49998798e50f939" => :yosemite
    sha256 "9ba1e4692226a7d1941c18b4317758393d806c95a4ec8b8500010f920ff13247" => :mavericks
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
