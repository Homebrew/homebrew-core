class Log4shib < Formula
  desc "Forked version of log4cpp for the Shibboleth project"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/log4shib"
  url "https://shibboleth.net/downloads/log4shib/2.0.1/log4shib-2.0.1.tar.gz"
  sha256 "aad37f3929bd3d4c16f09831ff109c20ae8c7cb8b577917e3becb12f873f26df"
  license "LGPL-2.1-only"

  livecheck do
    url "https://shibboleth.net/downloads/log4shib/latest/"
    regex(/href=.*?log4shib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "904dcc273d28ad65713782b2a01ee3a25997236147ac2281f3193148f5b22d16"
    sha256 cellar: :any,                 arm64_sequoia:  "8f3ca9cfd6b2cdc5d7487bcba05d48704e32a91a976addec41677d45525522a6"
    sha256 cellar: :any,                 arm64_sonoma:   "b4e8f90a884b5a2afc47ee2fb0a1d13a4731b4e03df4d3f5d432bf6b5ae41196"
    sha256 cellar: :any,                 arm64_ventura:  "c2bc8d9323dd44d769a0b9f139951bdd648467e8eb89d75dd47154751ef8e72d"
    sha256 cellar: :any,                 arm64_monterey: "0a24e1932a0b752006d448741f713646761e8d827e8615aa69575b3de674a85f"
    sha256 cellar: :any,                 arm64_big_sur:  "450ddfec54aca621297964385847c9ac0207dd1cf41d67222bf9f0fcb1207360"
    sha256 cellar: :any,                 sonoma:         "426c449a2af448af0262f97986cf4f60c23fa570501568526708a8010c9c5be2"
    sha256 cellar: :any,                 ventura:        "5eca207602aa861957c57cc05e191ee5d22fc2cec69761c9b4d78d7429369b7e"
    sha256 cellar: :any,                 monterey:       "7a8f70e280df362c5f85191ee9586c40436da110824674fb7e451d0a177b165f"
    sha256 cellar: :any,                 big_sur:        "0eddc0326cf4fbbf0eafe1bf6ebf1c69f55eabc218527624f47871be8fad3d04"
    sha256 cellar: :any,                 catalina:       "dd41c1980bae36dbbfd7c5ae5fc896354a95592a78f3b3f76b7b8ab35ab02329"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3bdf6274c47d7e6b14b257917453edcdf85fb1b3295e39b7ad1819d2759b4c4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b91c63f0b4e7b7aeeddfee541c3e7a0392438d9fa8ec2576b8f08e1bf7a711f"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
    (pkgshare/"test").install %w[tests/log4shib.init tests/testConfig.cpp tests/testConfig.log4shib.properties]
  end

  test do
    cp_r (pkgshare/"test").children, testpath
    system ENV.cxx, "testConfig.cpp", "-I#{include}", "-L#{lib}", "-llog4shib", "-o", "test", "-pthread"
    system "./test"
  end
end
