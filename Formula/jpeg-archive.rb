class JpegArchive < Formula
  desc "Utilities for archiving JPEGs for long term storage"
  homepage "https://github.com/danielgtaylor/jpeg-archive"
  url "https://github.com/danielgtaylor/jpeg-archive/archive/v2.2.0.tar.gz"
  sha256 "3da16a5abbddd925dee0379aa51d9fe0cba33da0b5703be27c13a2dda3d7ed75"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "41ac0d9c5bd290d77e7e5548a2257c6455f9f87265b06b5dc4e02ac7836dfc22" => :big_sur
    sha256 "222d7258f63f000794693bc5912c88ce42d0a33473a8acbbc585821655c9b8dd" => :catalina
    sha256 "2df1b3a007b7553addc977582d0c38d5007892f9e8a866a4fc9cda9b8f3b2af2" => :mojave
    sha256 "6f873847a8c7ad6420fe7700219ae13be39d12075c92921b364cb059ed5bf552" => :high_sierra
  end

  depends_on "mozjpeg"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/jpeg-recompress", test_fixtures("test.jpg"), "output.jpg"
  end
end
