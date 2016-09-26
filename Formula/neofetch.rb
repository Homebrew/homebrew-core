class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/1.7.tar.gz"
  sha256 "c5e492041b4eaf01a42e8fafb6f224bf9b58bf5b90e7408f84180da4db67ed62"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be4cc07f6463ae123b3702fb67e5f2c2c9ffa1f2ddc1a73383c5c7d0696de4bb" => :sierra
    sha256 "2ef8e1115c21b1932362e829c50e06d7a493bee18f254042d224560f4e7d5052" => :el_capitan
    sha256 "73d764934acf748f11b6540425ad08c1454dc98bd4571bb6d503d3ff793824eb" => :yosemite
    sha256 "15f36b6e099dba428645a9c125f9e5f70537949a66a10c280f48a693df0516c8" => :mavericks
  end

  depends_on "screenresolution" => :recommended
  depends_on "imagemagick" => :recommended

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch", "--test", "--config off"
  end
end
