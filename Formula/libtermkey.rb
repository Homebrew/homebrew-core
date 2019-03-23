class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.22.tar.gz"
  sha256 "6945bd3c4aaa83da83d80a045c5563da4edd7d0374c62c0d35aec09eb3014600"

  bottle do
    cellar :any
    sha256 "3b603560f59e5f26a226da5640a605e9ef64922ac5aafb5e67b278052d7cbc38" => :mojave
    sha256 "f671985c23c211f27f26dcb6808f710163b9a20db6f74e78be454ed416d8169f" => :high_sierra
    sha256 "bd4641beb0d85c37540e6edbbec6dba3150c8a365f33f1ef065179b90eac1cb6" => :sierra
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "unibilium"

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
