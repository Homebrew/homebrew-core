class Hyperestraier < Formula
  desc "Full-text search system for communities"
  homepage "https://dbmx.net/hyperestraier/"
  url "https://dbmx.net/hyperestraier/hyperestraier-1.4.13.tar.gz"
  sha256 "496f21190fa0e0d8c29da4fd22cf5a2ce0c4a1d0bd34ef70f9ec66ff5fbf63e2"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?hyperestraier[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "fddfdaa28011b5308a0195b816212d061a3b707dce5275ff26bb47ab09e22841"
    sha256 cellar: :any,                 arm64_sequoia:  "18f652254c3b115ffe6fad67be39dee791ef6b8f456122618762417eef74f4cb"
    sha256 cellar: :any,                 arm64_sonoma:   "5ac8a21fdb6d25f1855c3ab56253357c1938d3fe45d35f449e23dc28dd997a38"
    sha256 cellar: :any,                 arm64_ventura:  "381f8cb7f35472802af7f859b9b5369427a9260cf2470917f74f0e43d78915ec"
    sha256 cellar: :any,                 arm64_monterey: "4c7b331c57a8dc648150b89336b93cd18c172bce495a2fe5f7e351037d640305"
    sha256 cellar: :any,                 arm64_big_sur:  "77cc656687e473f7ae65dac6d4efb0ed75538f22890a3f48251791c1947487d0"
    sha256 cellar: :any,                 sonoma:         "c981ea80d0221e330581cbe313a598f79776c62e8cd4100a274f3dcb2b435feb"
    sha256 cellar: :any,                 ventura:        "ecc6438dbf55e4e3fde88968da4cf9c071b97436e94cb21e3daadd04f5ff4052"
    sha256 cellar: :any,                 monterey:       "e97a30177dd2112ae7ef36b2165213874faa7a4ef1e40dd6433ccfdd3eae7ac2"
    sha256 cellar: :any,                 big_sur:        "98338e8f67c7cba1df436607f09415415e39a38f695805ddd94720326eae9212"
    sha256 cellar: :any,                 catalina:       "0304cb2db3ed4e35c12ccaac0251ea19f7fd4c0f2a5b9f3ffad0f201f7f4357c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "82e4346da884ac2a0ef08c094839ff64c4f689a2d036dc4be0db5f7d86af69ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67da1265df5336838e42f563b8b90041d83d848739bf7972950de444cef78650"
  end

  depends_on "pkgconf" => :build
  depends_on "qdbm"

  def install
    system "./configure", *std_configure_args
    if OS.mac?
      system "make", "mac"
      system "make", "check-mac"
      system "make", "install-mac"
    else
      system "make", "LIBS=-lqdbm -lm"
      system "make", "check"
      system "make", "install"
    end
  end

  test do
    system bin/"estcmd", "version"
  end
end
