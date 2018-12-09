class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.12.1.tar.gz"
  sha256 "bd17cf67784f2ea0a2e0298761c662c80fddf6700c065f6689eb353e2144c987"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "82636980a98589818a65a844f5549fdb8114f74f792ce08c1fe39bf3d3b489b4" => :mojave
    sha256 "c3acb05edca5afae5722aea2b07d8c7645f54d8b87e8edb419ef8da411008fd2" => :high_sierra
    sha256 "7759e0daa3f929cfbbe892c3f07bfd25f5fe2a85a8f14e5875e309b79e223ceb" => :sierra
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
