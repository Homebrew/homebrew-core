class Dmalloc < Formula
  desc "Debug versions of system memory management routines"
  homepage "https://dmalloc.com/"
  url "https://dmalloc.com/releases/dmalloc-5.6.1.tgz"
  sha256 "4ac877aec5c8934ce075a14c5f637e5483186c7506acd23a186cc8f5eb3c0d71"
  license "ISC"

  bottle do
    cellar :any_skip_relocation
    sha256 "e905c1a99ca4cd0779c103e2c240f010d3e49d495b8b8ed32f0f02db13b159e9" => :big_sur
    sha256 "2b705d8c3d8892274d1176570f95cac79490eb410c8a1db29d84ec526fb9c0d6" => :catalina
    sha256 "19bb3f93176f545899dfaa7f752d27e16fb7be0d4baaac50a0c5d1b72cafac9e" => :mojave
  end

  def install
    system "./configure", "--enable-threads", "--prefix=#{prefix}"
    system "make", "install", "installth", "installcxx", "installthcxx"
  end

  test do
    system "#{bin}/dmalloc", "-b", "runtime"
  end
end
