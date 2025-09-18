class Libident < Formula
  desc "Ident protocol library"
  homepage "https://www.remlab.net/libident/"
  url "https://www.remlab.net/files/libident/libident-0.32.tar.gz"
  sha256 "8cc8fb69f1c888be7cffde7f4caeb3dc6cd0abbc475337683a720aa7638a174b"
  license :public_domain

  livecheck do
    url "https://www.remlab.net/files/libident/"
    regex(/href=.*?libident[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "79ba04c7084f4d774e85a799733bf4e79676f6ef0d5fc7c9036db9fd2e2b97e5"
    sha256 cellar: :any,                 arm64_sequoia:  "2446047586d94ec64540aae081f818a68642475be91609bb360772af74d8236f"
    sha256 cellar: :any,                 arm64_sonoma:   "ec5e66033f45c75ae856163de64dec8196438c77f2d7183595361d1cc2992a5b"
    sha256 cellar: :any,                 arm64_ventura:  "b3aacfbacdc98c637bc19401da959466566c13914d88be0a500a4ccd8c0e35fa"
    sha256 cellar: :any,                 arm64_monterey: "005fdffe6633e849bc26051b739a0fc10d72ecb25335bb04aea9286b19dbd196"
    sha256 cellar: :any,                 arm64_big_sur:  "3e1eeb778ba25f9b32ca28ea6b4b9a83a625c6a9e91784ad0e846e5a143da513"
    sha256 cellar: :any,                 sonoma:         "bb6e01e06cece16e7ec873b2b4060585ea3248a930e5bdf018c65de9b6901c78"
    sha256 cellar: :any,                 ventura:        "6bbf7d591e74f0698dba58c353bb1d5d7029ef68192487f4f53d1a4be538f899"
    sha256 cellar: :any,                 monterey:       "31ddce221ecaa52ab7d4cc10ccac2421043782f029a1a6643bcc886a7c1b922e"
    sha256 cellar: :any,                 big_sur:        "50e093a609acac219853ba89a884408bebcddd23b7ae23faad9476618649cbe7"
    sha256 cellar: :any,                 catalina:       "4482a61d30a1ac68265e91eafb45efdc734881d0a032e4b483707545a4ce98e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9696db63c01fd542845885f59973bf8b7628f34e7d654248f474e805ae91c182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f80a93f7750a66e987f21af7db62ba4f72c2c277036049915d3c8e6a8b044cf2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # Run autoreconf to regenerate the configure script and update outdated macros.
    # This ensures that the build system is properly configured on both macOS
    # (avoiding issues like flat namespace conflicts) and Linux (where outdated
    # config scripts may fail to detect the correct build type).
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end
end
