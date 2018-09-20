class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.11.0.tar.gz"
  sha256 "ef3f7d6ce0b726530973d9348a94fd91f9d02d30851ef3257ff538af4af571b6"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "30cb1d3cd0c76748175727c4de5c8c98d5fdd8d94fe4254dfc81d4cad7943491" => :mojave
    sha256 "502b6a1a71ad2011885eaf6172e20a5cf626e16c201357bb1072aab7f9b77ed7" => :high_sierra
    sha256 "18799640f91b1210ccd5d1349f34c1c91b32cf3603bc2ea442b68ce0694f74dd" => :sierra
    sha256 "30ae62ba7e76e4ec3e73e5454a3d96bb607bddee02af6a1e7644b077940dd52e" => :el_capitan
  end

  depends_on "dmd" => :build
  depends_on "pkg-config" => :recommended

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
