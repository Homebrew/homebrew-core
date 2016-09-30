class Phoon < Formula
  desc "Displays current or specified phase of the moon via ASCII art"
  homepage "https://www.acme.com/software/phoon/"
  url "https://www.acme.com/software/phoon/phoon_14Aug2014.tar.gz"
  version "04A"
  sha256 "bad9b5e37ccaf76a10391cc1fa4aff9654e54814be652b443853706db18ad7c1"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef7e685f7a9894e894807a555c4a9d52dd947184c15986f0a5578a46d892e46a" => :sierra
    sha256 "ae91a1dc089678416ddeab9bd3dfbe76f0fd9f4789a86b187740167d0658926d" => :el_capitan
    sha256 "d6f259769364eab6cacb4e45301f0ab8cd6edab369da99b4ecfbef7927791adc" => :yosemite
    sha256 "378c1f09dcffbd0a0fd79cbcbe9a988d8505fa9b657fc803e6c0e5bb62545047" => :mavericks
    sha256 "e6ddb6af5a0f4f1fe42ad4cb653434159fb9849d364fea7bb2e2784e7e0d8fa6" => :mountain_lion
  end

  def install
    system "make"
    bin.install "phoon"
    man1.install "phoon.1"
  end
end
