class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/resources/software/pazpar2/"
  url "https://ftp.indexdata.com/pub/pazpar2/pazpar2-1.14.1.tar.gz"
  sha256 "9baf590adb52cd796eccf01144eeaaf7353db1fd05ae436bdb174fe24362db53"
  license "GPL-2.0-or-later"
  revision 10

  livecheck do
    url "https://ftp.indexdata.com/pub/pazpar2/"
    regex(/href=.*?pazpar2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4185debb82ea7516fdd544cf8a7f0509cf018fe83adc7c60434fbf7b31710dff"
    sha256 cellar: :any,                 arm64_sequoia: "672d6de49b46f8aedaabb96210d47e490889528e3d75588bbd164ccbcb4eab89"
    sha256 cellar: :any,                 arm64_sonoma:  "f87a262cb03fd2f25bcef92c949f94eb27bc1dec9e7cbcb4ed9a38e82192bdfc"
    sha256 cellar: :any,                 sonoma:        "d6fad2c51dc9f9a91944ea537d6882bb8c8bfeacf207525decf241c0c8de5cf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfdde53eaffee03dda9094a5e2d53ad6a3804381b51c6aedf99135f83822fdcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e7655016434cf9e1d7d6a4ca97cb3272a255c07f51bb087ca80e0f06eca1023"
  end

  head do
    url "https://github.com/indexdata/pazpar2.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  depends_on "icu4c@78"
  depends_on "yaz"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

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
