class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.21.tar.xz"
  sha256 "4ca0d1e0d01366fe3e0cf490d88d154df511278fb595638713be3ca675665855"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/mpop/download/"
    regex(/href=.*?mpop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2439a807bef10bd2cffcbb38c61134bb112a8800e7814b6da5e517772bd9b187"
    sha256 arm64_sequoia: "150ff82a6b04b43d23e1bd2dd829aada62ce3ea5d9b3fed02b39576f4f63e54a"
    sha256 arm64_sonoma:  "1153dc80d795fce29566e64d3ef7f2af6f87576253da13a43328713ba7251a06"
    sha256 arm64_ventura: "2d583441a27b2a280df6638d0f84f3b13a36c3636a8dd688ec85ba452fccb0f4"
    sha256 sonoma:        "1f53b046ff585b6881305ed39356cf3f17183634e0c36d2efe9368e4cf00c9a2"
    sha256 ventura:       "1d439effaaa6da0bbc6ec4a4ecc99bda8ee74e7424f368f06de36a16a597da5f"
    sha256 arm64_linux:   "b74c1df7321d6efde1abe975639b29caaf4bcb45e9e6b5198c407f689636792b"
    sha256 x86_64_linux:  "2e1ee9de528062ddb2bbe3e5338e6b8856bfa295c5afd755d77574e3adc3e69d"
  end

  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libidn2"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
