class Mhash < Formula
  desc "Uniform interface to a large number of hash algorithms"
  homepage "https://mhash.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz"
  sha256 "3dcad09a63b6f1f634e64168dd398e9feb9925560f9b671ce52283a79604d13e"
  license all_of: ["LGPL-2.0-or-later", "LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/mhash[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "4c77322acecec89a57350e794b5712a3f2cf530d0550000918584f8071a9c563"
    sha256 cellar: :any,                 arm64_sequoia:  "f9b2ec3b67100dfe39ef4bb32671b26b5dbff6044b02ddae177b9bb1429ae036"
    sha256 cellar: :any,                 arm64_sonoma:   "d9cc9da019d2ce0fe3aab219247d9ebd9f2fb744af69871d13dc97925e0e7295"
    sha256 cellar: :any,                 arm64_ventura:  "63173c41e68e4510a36b6c3301d8f556a5c15010bff40258853f4ec735c74c68"
    sha256 cellar: :any,                 arm64_monterey: "f4f6e0a5a12cde078c2397874e309565d84a5599cbad4d5772ee13131deba98e"
    sha256 cellar: :any,                 arm64_big_sur:  "4f7da0cd859fc828d90946d6c6b80d80a60a85ffe4f82f9dd299ff1b8ba1bb54"
    sha256 cellar: :any,                 sonoma:         "bf4915b6d6d2e38c61c22948831c93cdd30b4db8ce5d234066f0238a3fbc7805"
    sha256 cellar: :any,                 ventura:        "751e17fd25843aebabf5c229d75476f6e854041c4a233329a7147b02e7050d87"
    sha256 cellar: :any,                 monterey:       "a8dbb4a5d3b15a10104683fdea162c85714cc0f4ef6f313c06aab7ddd0d1d42a"
    sha256 cellar: :any,                 big_sur:        "4553e5e48c17e06ad3290dd6ceabb6c9fee21be5b70194c03dd03d7bda873209"
    sha256 cellar: :any,                 catalina:       "d7d0a96656fbae5b279223d120bfe456c775a0c751090049bcf3ffffb2231761"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "55c3040b1081fba7cad5ff2ccd248b37b8face8513a609bdeff9a47c31241713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32a5e81c29e8407754448e5aa7f1f8ea2328bc5ce266ab5f3b350e3174373900"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # Regenerate the very old configure script that isn't suitable for modern macOS.
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "mhash.h"
      int main() {
        MHASH td;
        return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-L#{lib}", "-lmhash", "-o", "test"
    system "./test"
  end
end
