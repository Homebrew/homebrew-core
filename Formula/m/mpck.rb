class Mpck < Formula
  desc "Check MP3 files for errors"
  homepage "https://checkmate.gissen.nl/"
  url "https://checkmate.gissen.nl/checkmate-0.22.tar.gz"
  sha256 "104e5002c4796759c3fdbb987c531f82236bd622399e323b2a406c88ed82cad5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://checkmate.gissen.nl/download.php"
    regex(/href=.*?checkmate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "79cfebd954e23769957b0f14e6832d7ef024b514d259f47b9f1fb3c49940083c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1998cfe1d10043a5304f0ca5d157fa43569569c7e0316f3b5f09bcf2f9ed1c7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cd158561858d161569f1d79edd398437c9424c9312ec59c8da588e23fb3c61eb"
    sha256 cellar: :any,                 arm64_linux:       "e2905906761bca678f4ed082f5b4e4529f4530660b23ab951b36b27e3abf9ed9"
    sha256 cellar: :any,                 x86_64_linux:      "d6f410b7db70ddfdd09e5aa2d49b1104913bf7c21efe761c8a680a431c80649e"
  end

  deny_network_access!

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"mpck", test_fixtures("test.mp3")
  end
end
