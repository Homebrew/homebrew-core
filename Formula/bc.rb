class Bc < Formula
  desc "arbitrary precision numeric processing language"
  homepage "https://www.gnu.org/software/bc/"
  url "https://ftp.gnu.org/gnu/bc/bc-1.07.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/bc/bc-1.07.1.tar.gz"
  sha256 "62adfca89b0a1c0164c2cdca59ca210c1d44c3ffc46daf9931cf4942664cb02a"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc78f574106704c8d8eff1d02ac51ccfa24f0ec33e83cef435e9397ad8d31bdc" => :sierra
    sha256 "34291df270a235ffa2465551c4558c7d4e8b1f77ad199b579f2a82e8f140477e" => :el_capitan
    sha256 "2266c0522e31e0ad9ac9ac1fd3dc7ccd655dac02d4fce600cdbb19353761deb3" => :yosemite
  end

  keg_only :provided_by_osx

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--infodir=#{info}",
      "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/bc", "--version"
    assert_match "2", pipe_output("#{bin}/bc", "1+1\n")
  end
end
