class JpegArchive < Formula
  desc "Utilities for archiving JPEGs for long term storage"
  homepage "https://github.com/danielgtaylor/jpeg-archive"
  url "https://github.com/danielgtaylor/jpeg-archive/archive/2.1.1.tar.gz"
  sha256 "494534f5308f99743f11f3a7c151a8d5ca8a5f1f8b61ea119098511d401bc618"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b120d35b36e93a25730a5b5a074ecf0b0c8b10776c248bae55d91f924e320bf" => :sierra
    sha256 "92d2c0b15ef19ef8f5a56cb0360f1ebaf897e5abf0040df6d8d49209dad5ae4d" => :el_capitan
    sha256 "09a1ace83762b6f6f03eef2d86508d2c318f92657ec4ee6b763f2112003f02c2" => :yosemite
    sha256 "2edb74f1692d640928729274949d673740dc08963e7abc99bb249da1bc1a2923" => :mavericks
    sha256 "d28abe9b06370bce61d4520aa0c7943fc61eb70a847a01a3c541d211b542a22d" => :mountain_lion
  end

  depends_on "mozjpeg"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/jpeg-recompress", test_fixtures("test.jpg"), "output.jpg"
  end
end
