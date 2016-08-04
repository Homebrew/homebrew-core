class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/about"
  url "https://github.com/dlang/dub.git", :tag => "v1.0.0", :revision => "b59af2b8befb4fad4157d8c9cc86dba707b2fc87"

  head "https://github.com/dlang/dub.git", :shallow => false

  bottle do
    sha256 "072b9fa9d4907e79978c78f573d3a487f7ea6ca567d813d8d7311d1c43fbffee" => :el_capitan
    sha256 "dd641577df4e3a73fa797e97a268c606d0ba4160623bfa7ec0683c162fb8c578" => :yosemite
    sha256 "1c05ee4b3f609f81cd1507e22706befa2b78b945b8e2a7560d86e0a13746e845" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "dmd" => :build

  def install
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    system "#{bin}/dub; true"
  end
end
