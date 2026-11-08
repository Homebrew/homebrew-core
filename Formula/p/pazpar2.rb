class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/resources/software/pazpar2/"
  url "https://ftp.indexdata.com/pub/pazpar2/pazpar2-1.14.1.tar.gz"
  sha256 "9baf590adb52cd796eccf01144eeaaf7353db1fd05ae436bdb174fe24362db53"
  license "GPL-2.0-or-later"
  revision 11

  livecheck do
    url "https://ftp.indexdata.com/pub/pazpar2/"
    regex(/href=.*?pazpar2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "02e692e93c7935ef8f470bf2d59aff3d18539a1853c001ba2910152a8bd490dc"
    sha256 cellar: :any, arm64_tahoe:       "c80a77317285e1e6a8137c764b37e8d6021a7a7cec5ccde762c0ecd4bfd88a92"
    sha256 cellar: :any, arm64_sequoia:     "0a65a902f7174f8d2a350808d37a7abddded46dbd7336b132a6e6fcfc80f0051"
    sha256 cellar: :any, arm64_linux:       "15ee2ebdea60cf5475cf8178ac8eff23ab0fd4becceb18f7e54f2833aac0dd19"
    sha256 cellar: :any, x86_64_linux:      "ada341c49d3408eb6ced92202fa3727b4785179613c0abcf476c58d2e82b1435"
  end

  head do
    url "https://github.com/indexdata/pazpar2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  depends_on "icu4c@79"
  depends_on "yaz"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  allow_network_access! :test

  def install
    system "./buildconf.sh" if build.head?
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    (testpath/"test-config.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <pazpar2 xmlns="http://www.indexdata.com/pazpar2/1.0">
        <threads number="2"/>
        <server>
          <listen port="8004"/>
        </server>
      </pazpar2>
    XML

    system sbin/"pazpar2", "-t", "-f", testpath/"test-config.xml"
  end
end
