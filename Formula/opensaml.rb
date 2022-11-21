class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/3.2.1/opensaml-3.2.1.tar.bz2"
  sha256 "b402a89a130adcb76869054b256429c1845339fe5c5226ee888686b6a026a337"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?opensaml[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "35496d4d3dccfdd70c66ef467813d3063812425933bd56c7546f4c5ea0daf4e9"
    sha256 cellar: :any,                 arm64_monterey: "e6a5d7caddd133a1b4533322a9c2be90a6793f7f88da3727e9de3e84c5b3b4bd"
    sha256 cellar: :any,                 arm64_big_sur:  "647a2ea6d83c6241687d510a287ba2f1c66d39e81c27662f5e3de493a39313cb"
    sha256 cellar: :any,                 ventura:        "1b776b27bea4605592a95336032703823beed2de18b090559dd4ccbc1f22acea"
    sha256 cellar: :any,                 monterey:       "7088fd876aaca086bb9d4caf6e1a1fb20d13f1852eddaa8d02b20b9d59cc759a"
    sha256 cellar: :any,                 big_sur:        "9f5d89872645f58df8fc02bf425b310df6353c43940a0df4d7d0cfd20e48afd2"
    sha256 cellar: :any,                 catalina:       "0a96d46a06f13d8f5a2a0552f28a38122417ac9668a5ac7e261f0d3cef36a5f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96605b6bbff2f833df39964dced755d4f059713833c9be5456295dd07073b37a"
  end

  depends_on "pkg-config" => :build
  depends_on "log4shib"
  depends_on "openssl@1.1"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.cxx11

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "see documentation for usage", shell_output("#{bin}/samlsign 2>&1", 255)
  end
end
