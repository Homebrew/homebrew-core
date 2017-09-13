class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/downloads/fuse-zip-0.4.2.tar.gz"
  sha256 "3d4ee113d4c7918ad3c660f8088473d5fabf67b3476fef16ec7f5bd8a4182fdc"
  head "https://bitbucket.org/agalanin/fuse-zip", :using => :hg

  bottle do
    cellar :any
    sha256 "0db3a9d8a30e24848ccfa2553d1b470f2b8c115e41a99e4a2cb282f110053f26" => :sierra
    sha256 "0f443c4299364c8aa30b041c2e332e89623eb48a9a08543d5527b4020bf034cb" => :el_capitan
    sha256 "d11e97976dbf996bfcab165624625e294b0a4f6bd46bc033d70c9860de90b327" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libzip"
  depends_on :osxfuse

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system bin/"fuse-zip", "--help"
  end
end
