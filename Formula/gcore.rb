class Gcore < Formula
  desc "Produce a snapshot (core dump) of a running process"
  homepage "http://osxbook.com/book/bonus/chapter8/core/"
  url "http://osxbook.com/book/bonus/chapter8/core/download/gcore-1.3.tar.gz"
  sha256 "6b58095c80189bb5848a4178f282102024bbd7b985f9543021a3bf1c1a36aa2a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "624d85ab5533dec9806d4b89c2abf60ef193b0fea0bcf4fb135d2e84ced3631c" => :sierra
    sha256 "6ba5c2d5212f291b6410e9770e4bd8863f11462720c5f92898075d01acf0fb8e" => :el_capitan
    sha256 "4b098515f445f46942b8b7deab79f03206441d1ba95aaa65ce5da3c9e081a17e" => :yosemite
    sha256 "6479ee2516b07716c506155dee9e9d6be8484ae5f8ac044945644eb22db49a3b" => :mavericks
  end

  def install
    ENV.universal_binary
    system "make"
    bin.install "gcore"
  end
end
