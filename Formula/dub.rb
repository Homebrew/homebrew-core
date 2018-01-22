class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.7.1.tar.gz"
  sha256 "baa8c533f59d83f74e89c06f5ec7e52daf3becb227c7177a9eeab7159ba86dbc"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "8a6e8ed83b23822520cd4859bb06f40a28f1a2f54b273a30cb98dc5219eee5c0" => :high_sierra
    sha256 "185b3d1cefd8ba0e3b6f962d34aa40052a9c53c5dc8281a2593be43a1ad7b0e9" => :sierra
    sha256 "6cba8190f08671374747acb22fb01cfefc0cfbd4185acfd8281f12e4cc242519" => :el_capitan
  end

  depends_on "pkg-config" => [:recommended, :run]
  depends_on "dmd" => :build

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
