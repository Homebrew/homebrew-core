class Libident < Formula
  desc "Ident protocol library"
  homepage "https://www.remlab.net/libident/"
  url "https://www.remlab.net/files/libident/libident-0.32.tar.gz"
  sha256 "8cc8fb69f1c888be7cffde7f4caeb3dc6cd0abbc475337683a720aa7638a174b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4482a61d30a1ac68265e91eafb45efdc734881d0a032e4b483707545a4ce98e5" => :catalina
    sha256 "5afab4111e356d2c88632a89a6ffcf82b96530737b9c5c38ba0622900322ab79" => :mojave
    sha256 "f6bc989df22a80f3b0f8c6a2d458b5a00d9a4d48247cb7892877bd287e804a50" => :high_sierra
    sha256 "4fb8a991f9f83d499b32a814b2d68465327b7b77c0108764e58e4296a968100f" => :sierra
    sha256 "6236d3b4ee424795859cc64da30997ff67f7ac5bd42702e8eabe10f99339ca48" => :el_capitan
    sha256 "53db8e889d8efa34b4a3b6a145bcec2bcb53595e7db0cfdd55c8d857dff3a442" => :yosemite
    sha256 "d8e20cc9d2015b83785d4eb05110afc082a6389267df82546cc89e693dd2db6a" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
