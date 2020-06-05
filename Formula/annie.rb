class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.10.1.tar.gz"
  sha256 "3ad04d789db82a139b1fe914889af5a75fef8eca1e55446b25dae682a43e23e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "65fca7a2bc3fb3bf962f3a7b1e965b3509774bd0dd112dd5a30d780d47fc0cd7" => :catalina
    sha256 "e48782e3a1e925bdc15ff9294d30e81e205f79b6d77f3314ed5d0bb3bba3b77d" => :mojave
    sha256 "525db27d481218c6d32c64cda033315adcebd1dbe501fbb9f91ef0c4785c1fd1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"annie"
    prefix.install_metafiles
  end

  test do
    system bin/"annie", "-i", "https://www.bilibili.com/video/av20203945"
  end
end
