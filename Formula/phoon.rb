class Phoon < Formula
  desc "Displays current or specified phase of the moon via ASCII art"
  homepage "https://www.acme.com/software/phoon/"
  url "https://www.acme.com/software/phoon/phoon_14Aug2014.tar.gz"
  version "04A"
  sha256 "bad9b5e37ccaf76a10391cc1fa4aff9654e54814be652b443853706db18ad7c1"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee678f636d233dc19da162128f46e9a9d4e77fcb8c1eaee2ec5f435c3c616aae"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f341cb1767bdf7b8f8a81a2aa24c24f13c4fdf12ff0f2b6feec0c4525db5c55"
    sha256 cellar: :any_skip_relocation, catalina:      "253431291e5159ccd84ff5b7e967656067db28a708703270b2d4eb6e90613cd7"
    sha256 cellar: :any_skip_relocation, mojave:        "fc8ebcd250b06b5f4b387f7ff84c9935b10a0b2cd4515f2d1dfc993d64f528dc"
    sha256 cellar: :any_skip_relocation, high_sierra:   "b02d96f879caf26f69d807a5f7e4ede911e3d8d954fa3ab943e27efe6da15814"
    sha256 cellar: :any_skip_relocation, sierra:        "ef7e685f7a9894e894807a555c4a9d52dd947184c15986f0a5578a46d892e46a"
    sha256 cellar: :any_skip_relocation, el_capitan:    "ae91a1dc089678416ddeab9bd3dfbe76f0fd9f4789a86b187740167d0658926d"
    sha256 cellar: :any_skip_relocation, yosemite:      "d6f259769364eab6cacb4e45301f0ab8cd6edab369da99b4ecfbef7927791adc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "915e8751de7d3206d82f34273711cf49d09f646a16b7a7749a29867baf2028b8"
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
