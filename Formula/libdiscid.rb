class Libdiscid < Formula
  desc "C library for creating MusicBrainz and freedb disc IDs"
  homepage "https://musicbrainz.org/doc/libdiscid"
  url "http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.2.tar.gz"
  mirror "https://ftp.osuosl.org/pub/musicbrainz/libdiscid/libdiscid-0.6.2.tar.gz"
  sha256 "f9e443ac4c0dd4819c2841fcc82169a46fb9a626352cdb9c7f65dd3624cd31b9"
  license "LGPL-2.1"

  livecheck do
    url "https://ftp.osuosl.org/pub/musicbrainz/libdiscid/"
    regex(/href=.*?libdiscid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "49649e1da022773f63752c1ae6557cce46c33ecf14e7f1f8812015cd0c79e9f5"
    sha256 cellar: :any,                 arm64_monterey: "8acbeba6f3ab89c360994667a65f26cd8d8a974392cd27fcd6de9e4c20cd9b62"
    sha256 cellar: :any,                 arm64_big_sur:  "67f29aadedf99093c49470c6b99974ea94ed16491bf173e141055c501f4f26e3"
    sha256 cellar: :any,                 ventura:        "a5bc0b414b3664794edb2ddaa5e5c5c2119ef293ff6676d75f3e5f8e94f15e06"
    sha256 cellar: :any,                 monterey:       "6e1722879ecb396a04c3800cbf13ade90b60ac55fe9939126f3e12fd15d40d96"
    sha256 cellar: :any,                 big_sur:        "3388368253a64c71bd0cb6fcf0cd06102808d53cbaf3be99e482f175b5129952"
    sha256 cellar: :any,                 catalina:       "74dd7ef5362b91818107ef3c8c3edab443faf8a17662294a24573e5f476110c7"
    sha256 cellar: :any,                 mojave:         "f6a415ae56c151ccef5e10cc239675be8cbd7dcf60a8b9c88c87a756bda5bd9a"
    sha256 cellar: :any,                 high_sierra:    "3ffb586f09efcd9322a28bafc671292d0caf38edc18326c048a7390ced94979f"
    sha256 cellar: :any,                 sierra:         "6d43fee98239a6a600e59cce0f4f2ceda713bf27cc3d03bc8711d1c773ba84b6"
    sha256 cellar: :any,                 el_capitan:     "22e96d837cfe404cf268c41f6ce26c6b47eb8a991578ce1f18bcea862f9f1c91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e1a1df51835243be69651af2bee7c63dd3c067362478bc016cf39e84910e79a"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
