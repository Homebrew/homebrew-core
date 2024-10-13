class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/resources/software/pazpar2/"
  url "https://ftp.indexdata.com/pub/pazpar2/pazpar2-1.14.1.tar.gz"
  sha256 "9baf590adb52cd796eccf01144eeaaf7353db1fd05ae436bdb174fe24362db53"
  license "GPL-2.0-or-later"
  revision 6

  livecheck do
    url "https://ftp.indexdata.com/pub/pazpar2/"
    regex(/href=.*?pazpar2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4b341966194b7c988cc8b4af73502ce274e2d7ddc536fd73afeba131460a1b30"
    sha256 cellar: :any,                 arm64_sonoma:  "7ccf897d5318cea5448194edf0ec10ac3c5ada0b9f3b5cf129fe04e30719149f"
    sha256 cellar: :any,                 arm64_ventura: "7283dc88d4e3fb27f79439f7d7b8f289c1984735049e283c9b5a520f669eee38"
    sha256 cellar: :any,                 sonoma:        "021b31c71579217e9dd7fdbd4f752ce4b155261e2647e90328a763cd96b12076"
    sha256 cellar: :any,                 ventura:       "a84bf9859a3a7ba300b3a8325be1f714ffa1dabfa9b0ccd61b46d8351ffcc666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e1d83bdb114ba8c0039248e08a224e042e1abd8f233aeef9306afe1ff6c2d0d"
  end

  head do
    url "https://github.com/indexdata/pazpar2.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  depends_on "icu4c@75"
  depends_on "yaz"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    system "./buildconf.sh" if build.head?
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    (testpath/"test-config.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <pazpar2 xmlns="http://www.indexdata.com/pazpar2/1.0">
        <threads number="2"/>
        <server>
          <listen port="8004"/>
        </server>
      </pazpar2>
    EOS

    system "#{sbin}/pazpar2", "-t", "-f", "#{testpath}/test-config.xml"
  end
end
