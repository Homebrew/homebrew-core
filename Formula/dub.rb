class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.12.1.tar.gz"
  sha256 "bd17cf67784f2ea0a2e0298761c662c80fddf6700c065f6689eb353e2144c987"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccbef4fd6b1c6cd48a3f6e980f7b8b11aaca3cd8ba36f523a7cf9dd876742bad" => :mojave
    sha256 "58e31ca999a79568f3339bbc532bd546268d2046dc914e0a417f5e4b473d1833" => :high_sierra
    sha256 "87412d065b17d450e52759c86603f971a70907f80afd843ec81fe871281afccf" => :sierra
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
