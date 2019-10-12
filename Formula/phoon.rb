class Phoon < Formula
  desc "Displays current or specified phase of the moon via ASCII art"
  homepage "https://www.acme.com/software/phoon/"
  url "https://www.acme.com/software/phoon/phoon_14Aug2014.tar.gz"
  version "04A"
  sha256 "bad9b5e37ccaf76a10391cc1fa4aff9654e54814be652b443853706db18ad7c1"

  bottle do
    cellar :any_skip_relocation
    sha256 "253431291e5159ccd84ff5b7e967656067db28a708703270b2d4eb6e90613cd7" => :catalina
    sha256 "fc8ebcd250b06b5f4b387f7ff84c9935b10a0b2cd4515f2d1dfc993d64f528dc" => :mojave
    sha256 "b02d96f879caf26f69d807a5f7e4ede911e3d8d954fa3ab943e27efe6da15814" => :high_sierra
    sha256 "ef7e685f7a9894e894807a555c4a9d52dd947184c15986f0a5578a46d892e46a" => :sierra
    sha256 "ae91a1dc089678416ddeab9bd3dfbe76f0fd9f4789a86b187740167d0658926d" => :el_capitan
    sha256 "d6f259769364eab6cacb4e45301f0ab8cd6edab369da99b4ecfbef7927791adc" => :yosemite
    sha256 "378c1f09dcffbd0a0fd79cbcbe9a988d8505fa9b657fc803e6c0e5bb62545047" => :mavericks
  end

  def install
    system "make"
    bin.install "phoon"
    man1.install "phoon.1"
  end

  test do
    system "#{bin}/phoon"
  end
end
