class Jpeg < Formula
  desc "Image manipulation library"
  homepage "https://www.ijg.org/"
  url "https://www.ijg.org/files/jpegsrc.v9e.tar.gz"
  mirror "https://fossies.org/linux/misc/jpegsrc.v9e.tar.gz"
  sha256 "4077d6a6a75aeb01884f708919d25934c93305e49f7e3f36db9129320e6f4f3d"
  license "IJG"

  livecheck do
    url "https://www.ijg.org/files/"
    regex(/href=.*?jpegsrc[._-]v?(\d+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9f4b61fba5eac14705918c94e7f43ecfb7f20774d1c8195d15675ddce4e1b7d3"
    sha256 cellar: :any,                 arm64_monterey: "5d4520a90181dd83b3f58b580cd3b952cacf7f7aa035d5fd7fddd98c1e6210d1"
    sha256 cellar: :any,                 arm64_big_sur:  "27409eb75ac182025c27b4aa9c2290c40feec924cbe9edc095c754120c87bdf4"
    sha256 cellar: :any,                 ventura:        "60e8af1b1b966df8aa970865dd17930b67edd23e10d3c96495879030a3b6f5ee"
    sha256 cellar: :any,                 monterey:       "208af924cc7a42f53ab8ce50084eb76faadc3c1942e842484acbb2e74a54465c"
    sha256 cellar: :any,                 big_sur:        "085e31212006e6afefc6e5141a02a06cb5bdebdbc8ca5edba50de0d95dd495fc"
    sha256 cellar: :any,                 catalina:       "4c19f39c827ee7cdbc0f770b56c8ce553e94a5090e58da7eac3e2596b9408612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b15c19b1cfdee81b6c3ebb96b1a743157da600030f943c9e18cbbda0612924a"
  end

  keg_only "it conflicts with `jpeg-turbo`"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"djpeg", test_fixtures("test.jpg")
  end
end
