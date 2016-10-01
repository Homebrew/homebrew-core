class Aha < Formula
  desc "ANSI HTML adapter"
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.4.10.tar.gz"
  sha256 "bbfb55940cbd8c4cbf8eccededf30a9e3861feda2b9c50d76f55d384080641aa"
  head "https://github.com/theZiz/aha.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de2a2448df45ce8015c32cfa4929e0f7b97a44ccc34cb021007bc079a3c26955" => :sierra
    sha256 "ed91f263c063132ffcfda8216a5ace0a6af9bcf02d81d548625b038be7171507" => :el_capitan
    sha256 "357dff75a627e45d0c0d23c31b42656ce6db5646791ac3893fc6b6741e469098" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    out = pipe_output(bin/"aha", "[35mrain[34mpill[00m")
    assert_match(/color:purple;">rain.*color:blue;">pill/, out)
  end
end
