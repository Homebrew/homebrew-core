class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.13.0.tar.gz"
  sha256 "8c7ffdae0b49bd1a246f48e865610fc5b6f6bdf58057858f3ba7e9dae8368ee7"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1d5c305a6054c17180a7aef2eb4d0464fba0803c21277d4f2caa106a6596768" => :mojave
    sha256 "bd95b70c0faf1b4b185efe0bc61b25a2f791dd47e46c7ad78d5e6cfeddf5be07" => :high_sierra
    sha256 "5f0fdf02526e0731907cdb29b6c90989ac1feacde0910e06ada599e3cb511c5d" => :sierra
  end

  depends_on "dmd" => :build
  depends_on "pkg-config"

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
