class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.7.0.tar.gz"
  sha256 "5c4875cf4ced113d35f1da949524a2b366dff93049dffe98da95171bed6cd069"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "02dca616f9005a97e8a808132e4db53a7b09a7c68b57ba1b7c617bf2548fe9af" => :high_sierra
    sha256 "93a16cf901414234c4345df869c818cadced49f50d15f54ee3e75100e5b16641" => :sierra
    sha256 "dfc6c60757b75435bb16018ae05e4ea8c3de8137922bfdc7043a33492a985a7e" => :el_capitan
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
