class Osxutils < Formula
  desc "Collection of macOS command-line utilities"
  homepage "https://github.com/specious/osxutils"
  url "https://github.com/specious/osxutils/archive/v1.9.0.tar.gz"
  sha256 "9c11d989358ed5895d9af7644b9295a17128b37f41619453026f67e99cb7ecab"
  head "https://github.com/specious/osxutils.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "744e327d1fb2183de8785880c3f7a127abdd896977e3d30cade00933ea137521" => :mojave
    sha256 "d665cbec1973b73e1e1d290014786b95d36d9cfe7028fd69fa37f698d18e81dd" => :high_sierra
    sha256 "8021183b4ad9c646920020e51446e555210bbb24e22da923557e1e0370353dfd" => :sierra
    sha256 "3bd65cf2550b709c111e31db7cb7d829a9260ed5dd35a682c370ed01593c1989" => :el_capitan
  end

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "osxutils", shell_output("#{bin}/osxutils")
  end
end
