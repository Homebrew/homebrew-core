class Curseofwar < Formula
  desc "Fast-paced action strategy game"
  homepage "https://a-nikolaev.github.io/curseofwar/"
  url "https://github.com/a-nikolaev/curseofwar/archive/v1.2.0.tar.gz"
  sha256 "91b7781e26341faa6b6999b6baf6e74ef532fa94303ab6a2bf9ff6d614a3f670"
  head "https://github.com/a-nikolaev/curseofwar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ce2eaede3f4636c0ddb7a16d65ae6b750c9e20342715841e5cacefd3d61b0b7" => :mojave
    sha256 "b43f143f9fe919e2d88b241865513967054550a852fd62747ed759ac1a53500b" => :high_sierra
    sha256 "8a19536dcb6b4a3f508c800980d6300399d1b9d7af1683df7ea7f4dd502cf238" => :sierra
    sha256 "014a448d16cef523e97f898c952a74b08b379569f22d951189e90c9ee5056c11" => :el_capitan
    sha256 "6b1368e3d4875b19c9817c413037edbeaf49120519032b725207079b86913c8a" => :yosemite
  end

  def install
    system "make"
    bin.install "curseofwar"
    man6.install "curseofwar.6"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/curseofwar -v", 1).chomp
  end
end
