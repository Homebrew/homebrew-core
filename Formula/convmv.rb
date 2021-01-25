class Convmv < Formula
  desc "Filename encoding conversion tool"
  homepage "https://www.j3e.de/linux/convmv/"
  url "https://www.j3e.de/linux/convmv/convmv-2.05.tar.gz"
  sha256 "53b6ac8ae4f9beaee5bc5628f6a5382bfd14f42a5bed3d881b829d7b52d81ca6"

  livecheck do
    url :homepage
    regex(/href=.*?convmv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "20517059aabe3b68553cc8a756331db3692732cddd5f3cf10905189f1494ddef" => :big_sur
    sha256 "3b5226bc4a647dfcfacba43b505e94cd1c2ad5037f04660b267fe4d2f1a2158a" => :arm64_big_sur
    sha256 "203e34d5e76b55fabbf8548b93f749cd044ad843ca9062a916026e548332f7b0" => :catalina
    sha256 "8e5a0c8207cb0c57f1640c5a8c9a4a05cd9c8ffc68d922774cae4bfa56b691e6" => :mojave
    sha256 "856021a73afb22052e496ced9eb1a7386d810a6d75903aac99feb98298801ea8" => :high_sierra
    sha256 "cc6cf7ff9cfd8909a76e29dd6ddbdddc9ad95638e154b72a36fe6c255e3a367d" => :sierra
    sha256 "43278a7c7ef7720e20fed3179ff8519230678d3fd4e98f4b0e8e796b5fdb40ac" => :el_capitan
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/convmv", "--list"
  end
end
