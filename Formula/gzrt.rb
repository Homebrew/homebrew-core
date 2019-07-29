class Gzrt < Formula
  desc "Gzip recovery toolkit"
  homepage "https://www.urbanophile.com/arenn/coding/gzrt/gzrt.html"
  url "https://www.urbanophile.com/arenn/coding/gzrt/gzrt-0.8.tar.gz"
  sha256 "b0b7dc53dadd8309ad9f43d6d6be7ac502c68ef854f1f9a15bd7f543e4571fee"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d2f5fca0f32dd8a88d7aba3d8e6f926d89f74fa1748b9e7f618bdc76e3500fe" => :mojave
    sha256 "2e7f8e8743943f1e83c4b1ed6372fa3c4cab00f7a090dbb4f967b7fade1e5e20" => :high_sierra
    sha256 "da5c89596737f514900f32986dd9eb32f010c6c1b9f1643dd03a07eae7e383a7" => :sierra
    sha256 "01df00fd35c6eaee9d32da4644d694ce33deda79a9c3da0284b52694f94a9515" => :el_capitan
    sha256 "af8ffc53bcf606b0634537adfeb67733c27ec079fa0347de41c668dbb5cce037" => :yosemite
    sha256 "0df681add87a86ffad0954b1699e3d92613faad902184b24ed595bccb7d3897d" => :mavericks
  end

  def install
    system "make"
    bin.install "gzrecover"
    man1.install "gzrecover.1"
  end
end
