class Libbind < Formula
  desc "Original resolver library from ISC"
  homepage "https://www.isc.org/software/libbind"
  url "https://ftp.isc.org/isc/libbind/6.0/libbind-6.0.tar.gz"
  sha256 "b98b6aa6e7c403f5a6522ffb68325785a87ea8b13377ada8ba87953a3e8cb29d"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "d00556807ac67001b11a1d9c4084a679c425746b3f8637e430f29d13e760a0a9" => :catalina
    sha256 "504319b451c5cfa27ffc46ffdae91ba7a75b3fce9d78c9a02c3a1214d377b1b2" => :mojave
    sha256 "4cbde1938720903104389cb24f164f5fc3791953984888d62e0831a695dfeb2d" => :high_sierra
    sha256 "b5a4bc4b247b5cce0c637bb96335c5df27e2210c40cc89e19f9957f5aef1cbdb" => :sierra
    sha256 "d0a71d129904ac0529c6f8e789a41307caaeb0e6d9f33f30f23f4b3dbc61456d" => :el_capitan
    sha256 "c2eaf992dc37ce98d5936ba7e086c30a5da242bfe834e593dfb40d7d3e546923" => :yosemite
    sha256 "f59cf59e14f6192c962592a4411391413d929c8dfff81fdd8b4a82ce7c0d3f02" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make" # You need to call make, before you can call make install
    system "make", "install"
  end
end
