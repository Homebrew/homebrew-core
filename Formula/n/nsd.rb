class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.12.0.tar.gz"
  sha256 "f9ecc2cf79ba50580f2df62918efc440084c5bf11057db44c19aa9643cd4b5e8"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https://www.nlnetlabs.nl/downloads/nsd/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/nsd.git"
    regex(/^NSD[._-]v?(\d+(?:[._]\d+)+)[._-]REL$/i)

    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_sequoia: "85bb70cef58045b06ced5a968940b759002712735aed244bc11332a9f39dcb94"
    sha256 arm64_sonoma:  "25250277cb9ea1362f84c54ebedb00bf7d0495137bb6cd382837066827088565"
    sha256 arm64_ventura: "d9bfd250e34039636ce4b0f280f1355b2c1df8fb23a8d1f3fc79a3396dd88aeb"
    sha256 sonoma:        "46f180636949a9d29fdc7407781738e88e682310d17f75d8a149973c851aba28"
    sha256 ventura:       "17aaaf7af44e90ff1ed56862b487cff20aa5c07e88a5e062d81f01626bba8418"
    sha256 arm64_linux:   "74c83fbff5f64a0c06dc293f179c42f09ebef07e2d0053ba175e8d9fb7fbd180"
    sha256 x86_64_linux:  "5d1dff89d0761927aabd2c62ef96c1e304f1f411ee1b7f454792364c81aadf04"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@3"

  def install
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    system "./configure", "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"nsd", "-v"
  end
end
