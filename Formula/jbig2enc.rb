class Jbig2enc < Formula
  desc "JBIG2 encoder (for monochrome documents)"
  homepage "https://github.com/agl/jbig2enc"
  url "https://github.com/agl/jbig2enc/archive/0.29.tar.gz"
  sha256 "bfcf0d0448ee36046af6c776c7271cd5a644855723f0a832d1c0db4de3c21280"
  license "Apache-2.0"
  revision 1
  head "https://github.com/agl/jbig2enc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "04adc5219a6b9fd81d98e46b523e0026e3cd69f333421d17837a154d80ca3a6a"
    sha256 cellar: :any,                 arm64_monterey: "7f34bf27ad68b0a8f41b94e77ff7ac73222285c16c1fdeccc23ea5d402103d2b"
    sha256 cellar: :any,                 arm64_big_sur:  "2086a80027df8b8f6765552f9bd612067bded65ff59894354641966af9954e89"
    sha256 cellar: :any,                 ventura:        "69448ad02527c02f6353842bfc35cefbc74b64c4c91025a57036868311efea7b"
    sha256 cellar: :any,                 monterey:       "a9b5f6a0eeebd57052daedc8a7d50731f9f1a144b2da4622137620d77b4d9e06"
    sha256 cellar: :any,                 big_sur:        "fd54b93bae050fe3c02fe0322c97c77466491d6b8426e826acde2eb1149ce846"
    sha256 cellar: :any,                 catalina:       "2140d5d4884fb99e1e263a9cf90fb5f0584634435cdb8a4b7fbec0dc40368879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2446fafdf3ed1c16c60470dba4c325ca52f963ff4487e384f55bf27f71741946"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "leptonica"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
