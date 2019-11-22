class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.22.tar.gz"
  sha256 "6945bd3c4aaa83da83d80a045c5563da4edd7d0374c62c0d35aec09eb3014600"

  bottle do
    cellar :any
    sha256 "293f71f6cb8498f734910ada7ffe4e8e2ea2cb6121455318053d2a5951b272a8" => :catalina
    sha256 "efa6360ccb50275ee143410e57b4ff47b2d6bafd97d6f4feeb3cb3ee02050a2c" => :mojave
    sha256 "e3b848de428f811c1879530c043145152bf4b0e599ed642aa2845904d13f7081" => :high_sierra
    sha256 "3f8ce77603619d85de7127f317e276c0cd38a461c545cafeb7c875e7c89fe467" => :sierra
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "unibilium"

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
