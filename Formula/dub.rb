class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.4.0.tar.gz"
  sha256 "11e2604e61fb89152044927df1f87561640da8406ea4bdb35655572bbdfd77f0"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "d90795924f04dcd73daf64dae1f5c7ddb3c5515c83e3ab7a921ad92952ebc1b5" => :sierra
    sha256 "3e679d35a0c7e43321e49680b9bb3322cdbab28d662af211017d08236527f190" => :el_capitan
    sha256 "9b41c338802264a16d670bf1f0e90441ca4411992abcc8f9da33f49150785956" => :yosemite
  end

  depends_on "pkg-config" => [:recommended, :run]
  depends_on "dmd" => :build

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    if build.stable?
      assert_match version.to_s, shell_output("#{bin}/dub --version")
    else
      assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
    end
  end
end
