class Curseofwar < Formula
  desc "Fast-paced action strategy game"
  homepage "https://a-nikolaev.github.io/curseofwar/"
  url "https://github.com/a-nikolaev/curseofwar/archive/v1.3.0.tar.gz"
  sha256 "2a90204d95a9f29a0e5923f43e65188209dc8be9d9eb93576404e3f79b8a652b"
  license "GPL-3.0"
  head "https://github.com/a-nikolaev/curseofwar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "92c8a1650e5e18866211a79499abad640ff8ce8f49b54c50043e7f421d8d8e47" => :catalina
    sha256 "4ce2eaede3f4636c0ddb7a16d65ae6b750c9e20342715841e5cacefd3d61b0b7" => :mojave
    sha256 "b43f143f9fe919e2d88b241865513967054550a852fd62747ed759ac1a53500b" => :high_sierra
    sha256 "8a19536dcb6b4a3f508c800980d6300399d1b9d7af1683df7ea7f4dd502cf238" => :sierra
    sha256 "014a448d16cef523e97f898c952a74b08b379569f22d951189e90c9ee5056c11" => :el_capitan
    sha256 "6b1368e3d4875b19c9817c413037edbeaf49120519032b725207079b86913c8a" => :yosemite
  end

  def install
    system "make", "VERSION=#{version}"
    bin.install "curseofwar"
    man6.install "curseofwar.6"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/curseofwar -v", 1).chomp
  end
end
