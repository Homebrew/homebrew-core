class Libident < Formula
  desc "Ident protocol library"
  homepage "https://www.remlab.net/libident/"
  url "https://www.remlab.net/files/libident/libident-0.32.tar.gz"
  sha256 "8cc8fb69f1c888be7cffde7f4caeb3dc6cd0abbc475337683a720aa7638a174b"

  livecheck do
    url "https://www.remlab.net/files/libident/"
    regex(/href=.*?libident[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "b3aacfbacdc98c637bc19401da959466566c13914d88be0a500a4ccd8c0e35fa"
    sha256 cellar: :any,                 arm64_monterey: "005fdffe6633e849bc26051b739a0fc10d72ecb25335bb04aea9286b19dbd196"
    sha256 cellar: :any,                 arm64_big_sur:  "3e1eeb778ba25f9b32ca28ea6b4b9a83a625c6a9e91784ad0e846e5a143da513"
    sha256 cellar: :any,                 ventura:        "6bbf7d591e74f0698dba58c353bb1d5d7029ef68192487f4f53d1a4be538f899"
    sha256 cellar: :any,                 monterey:       "31ddce221ecaa52ab7d4cc10ccac2421043782f029a1a6643bcc886a7c1b922e"
    sha256 cellar: :any,                 big_sur:        "50e093a609acac219853ba89a884408bebcddd23b7ae23faad9476618649cbe7"
    sha256 cellar: :any,                 catalina:       "4482a61d30a1ac68265e91eafb45efdc734881d0a032e4b483707545a4ce98e5"
    sha256 cellar: :any,                 mojave:         "5afab4111e356d2c88632a89a6ffcf82b96530737b9c5c38ba0622900322ab79"
    sha256 cellar: :any,                 high_sierra:    "f6bc989df22a80f3b0f8c6a2d458b5a00d9a4d48247cb7892877bd287e804a50"
    sha256 cellar: :any,                 sierra:         "4fb8a991f9f83d499b32a814b2d68465327b7b77c0108764e58e4296a968100f"
    sha256 cellar: :any,                 el_capitan:     "6236d3b4ee424795859cc64da30997ff67f7ac5bd42702e8eabe10f99339ca48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f80a93f7750a66e987f21af7db62ba4f72c2c277036049915d3c8e6a8b044cf2"
  end

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "--force", "--verbose", "--install" if OS.mac?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
