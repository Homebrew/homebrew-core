class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2025.88.tar.bz2"
  sha256 "783f50ea27b17c16da89578fafdb6decfa44bb8f6590e5698a4e4d3672dc53d4"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?dropbear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a616913e00306a4699d97791ccd998feec82bff32373786b7e85bcd26cf0d00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9328cf8c07250bf2320af722633579e84db7c992f11d43ebc67aa85a3bbebad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb134cc3f5603b552af4a3b83d58e6576aac58a4a589537f8a1d87d73b1cde15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a17000ca546c8c5cb69b916d660bab2c9ab3341161d33a6a73f5d40e0dad2300"
    sha256 cellar: :any_skip_relocation, sonoma:        "db12fa6ae371b408f2ec14107afa41ef7eea2dfeb12cd267b186188e10a19b1b"
    sha256 cellar: :any_skip_relocation, ventura:       "f5dae867598a50af551fcd22893d6980830310fd01bac1d89c037e428b127085"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5252254322544bf05aa9cd1c0d78770b7cee10f037bd0f93d336794a81c51383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e275ebce599f0b89bdbdd74d0ac4083f61b4ea8b1d4b97b16ba80af6dd4a41af"
  end

  head do
    url "https://github.com/mkj/dropbear.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    ENV.deparallelize

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
