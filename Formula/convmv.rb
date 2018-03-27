class Convmv < Formula
  desc "Filename encoding conversion tool"
  homepage "https://www.j3e.de/linux/convmv/"
  url "https://www.j3e.de/linux/convmv/convmv-2.05.tar.gz"
  sha256 "53b6ac8ae4f9beaee5bc5628f6a5382bfd14f42a5bed3d881b829d7b52d81ca6"

  bottle do
    cellar :any_skip_relocation
    sha256 "805751537d94d301948209f644c89511b4a98128524256b057e6aed8953ee96c" => :high_sierra
    sha256 "2487ad46c8aaee4e31ad2b8bc1e6f539810857ed339bfe3aab801549a170b2b8" => :sierra
    sha256 "a39250872cd3158dd7a5de91c8ca45c77b6665aa721a8d7e14cec2670d616675" => :el_capitan
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/convmv", "--list"
  end
end
