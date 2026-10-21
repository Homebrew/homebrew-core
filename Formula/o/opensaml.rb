class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/3.3.1/opensaml-3.3.1.tar.bz2"
  sha256 "d8e24e070fc6bb80682632ca32c8569a9f3ef170ba57e3b82818322e75b6a37e"
  license "Apache-2.0"
  revision 2

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?opensaml[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "378f215d2d73f72c3ab321fe3ded8324ae5840a9c0d3628465cc9bbac91089f3"
    sha256 cellar: :any, arm64_tahoe:       "c3507a33631f583e325f1f00fcfad2390a9005ab7dd0bd40e6204ae699734e9c"
    sha256 cellar: :any, arm64_sequoia:     "85705f8c0882f2ead6f6b545529c5294bfbca6dc7e8dc99fce47d268abfe4cae"
    sha256 cellar: :any, arm64_linux:       "15031a901cf7433fab5b36e1ed3bdb1cc8973c25f856daf0a82861e3c4e3b8f3"
    sha256 cellar: :any, x86_64_linux:      "98c61bc6b6207472b2a0bf8ddc34d59c9d9378e628c5eb89a6449d5e7efedbb5"
  end

  depends_on "pkgconf" => :build
  depends_on "log4shib"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

  def install
    ENV.cxx11

    system "./configure", *std_configure_args
    system "make", "install"

    inreplace lib/"pkgconfig/opensaml.pc", prefix, opt_prefix
  end

  test do
    assert_match "see documentation for usage", shell_output("#{bin}/samlsign 2>&1", 255)
  end
end
