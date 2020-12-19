class Expbrew < Formula
  desc "Trying for Package Adding into the HomeBrew"
  homepage "https://github.com/SainathChallagundla/ExpBrew"
  url "https://github.com/SainathChallagundla/ExpBrew/archive/v0.0.1.tar.gz"
  version "0.0.1-start"
  sha256 "f45ed76a2d7cb794177524bd782a8b8216803d75760f2fb2dba9478829909fe4"
  license "MIT"
  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "cmake", ".", *std_cmake_args
  end

  test do
    assert_equal hash, Digest::SHA256.file("#{testpath}/test.wav").hexdigest
  end
end
