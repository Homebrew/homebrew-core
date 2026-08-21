class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/3.3.1/opensaml-3.3.1.tar.bz2"
  sha256 "d8e24e070fc6bb80682632ca32c8569a9f3ef170ba57e3b82818322e75b6a37e"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?opensaml[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5805c25d6cbc6a232a11171cbe6b42d4bd5cd79bb58a80eb58fc8897cb95d809"
    sha256 cellar: :any,                 arm64_sequoia: "07a24e559fba8ef6206aa142b47c40d15dd68ec6ecebfcf6ef4e249461a1ebfc"
    sha256 cellar: :any,                 arm64_sonoma:  "2433e81f6f75b41ace4f4b39a8bc336aad0d07324efe4f5758966ba8db3270be"
    sha256 cellar: :any,                 arm64_ventura: "30a5d4e496a4053fc99686974cca11d4b8be3d331fe55c0cec552d8171060730"
    sha256 cellar: :any,                 sonoma:        "11823d44fd8032eb8e3f61827de120b93656107a2e31fbeedc95a78c52e34017"
    sha256 cellar: :any,                 ventura:       "8045e1d48ada4b5fa6c2a524cda2dd2b31e33014e49d2894b9fdd134597703cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccf298955ba2cf7cc5c54feaab9baedd5faa1b351ea02525ceeda3d35d76e805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7113cf3ec71403d5a0c60bb4f6e9c358c60f57cf80e203d9cd34cb19f5d1898e"
  end

  depends_on "pkgconf" => :build
  depends_on "log4shib"
  depends_on "openssl@3"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

  def install
    ENV.cxx11

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "see documentation for usage", shell_output("#{bin}/samlsign 2>&1", 255)
  end
end
