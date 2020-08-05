class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.github.io/"
  url "https://github.com/atari800/atari800/releases/download/ATARI800_4_2_0/atari800-4.2.0-src.tgz"
  sha256 "55cb5568229c415f1782130afd11df88c03bb6d81fa4aa60a4ac8a2f151f1359"

  bottle do
    cellar :any
    sha256 "5bc2d96418e21a76809abfa2513f630cb207848b0894f27cda34b2f55bace81c" => :catalina
    sha256 "f5508c8a0021a0fcbd1e35d7a4313d8c9ba52ab937d0fde59ccc5f81e3c49ac0" => :mojave
    sha256 "497ce17afc99e76180b94b76b08c1aca973eab554ee3ccecfd14818c71e97035" => :high_sierra
  end

  depends_on "libpng"
  depends_on "sdl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-sdltest",
                          "--disable-riodevice"
    system "make", "install"
  end

  test do
    assert_equal "Atari 800 Emulator, Version #{version}",
                 shell_output("#{bin}/atari800 -v", 3).strip
  end
end
