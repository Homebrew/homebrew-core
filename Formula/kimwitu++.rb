class Kimwituxx < Formula
  desc "Tool for processing trees (i.e. terms)"
  homepage "https://www2.informatik.hu-berlin.de/sam/kimwitu++/"
  url "https://download.savannah.gnu.org/releases/kimwitu-pp/kimwitu++-2.3.13.tar.gz"
  sha256 "3f6d9fbb35cc4760849b18553d06bc790466ca8b07884ed1a1bdccc3a9792a73"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5dfd8382b50fc856ba741b79cf7077ae741549b8b8ff32ce727cfd7e8bd2a69" => :sierra
    sha256 "98c3516d1f3a9b17397354d8dde712f8a8c0f97ac919c65fc468ab4569534cc4" => :el_capitan
    sha256 "6b396c209bc1bc9df74df57f86e2d27a36817f2ed3a6ba2c5101879dec6ffb43" => :yosemite
    sha256 "850a6609b75b222e5443a2c293ecaec376dfa6fe2a3ba708d742c6fdb2537af7" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end
end
