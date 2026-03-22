class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2025.89.tar.bz2"
  sha256 "0d1f7ca711cfc336dc8a85e672cab9cfd8223a02fe2da0a4a7aeb58c9e113634"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?dropbear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d84b94d96972aef2cae86efbd60cba209324849b8130885f047988323742d98b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dca7fb55a145414f317ed95f4b3f9d4c2fe6831c9218f5630e4461ca4272554"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02fb8242ae08d7273b317cc13536cf9b044cb79ab9fda1d2e98e678df432b402"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab1c015d6d4dc3772539b65ac6dc80a0cb36fc9cea44ab30f7befe35c2bae637"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "939dd6c49ffb11771864b2f7dea73b00b23b154e298e019ca1a248be3b2a63f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0f6f864ac0ba514aed819c711b34957e5d765bdca7644738720a98a62b8eee4"
  end

  head do
    url "https://github.com/mkj/dropbear.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "linux-pam"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.deparallelize

    # It doesn't compile on macOS with these macros because of the missing `setresgid()` function
    # There's no option to disable it via `./configure` flags and upstream suggests to fix it
    # by changing `src/default_options.h` manually (see `CHANGES`)
    if OS.mac?
      inreplace "src/default_options.h" do |s|
        s.gsub! "#define DROPBEAR_SVR_DROP_PRIVS DROPBEAR_SVR_MULTIUSER", ""
        s.gsub! "#define DROPBEAR_SVR_LOCALSTREAMFWD 1", ""
      end
    end

    if build.head?
      system "autoconf"
      system "autoheader"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-pam",
                          "--enable-zlib",
                          "--enable-bundled-libtom",
                          "--sysconfdir=#{etc}/dropbear"
    system "make"
    system "make", "install"
  end

  test do
    testfile = testpath/"testec521"
    system bin/"dbclient", "-h"
    system bin/"dropbearkey", "-t", "ecdsa", "-f", testfile, "-s", "521"
    assert_path_exists testfile
  end
end
