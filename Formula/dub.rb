class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/about"
  url "https://github.com/dlang/dub.git", :tag => "v0.9.25", :revision => "777e0033e9ca502c134a6cca6b5a06d0e3f78617"
  head "https://github.com/dlang/dub.git", :shallow => false

  bottle do
    sha256 "072b9fa9d4907e79978c78f573d3a487f7ea6ca567d813d8d7311d1c43fbffee" => :el_capitan
    sha256 "dd641577df4e3a73fa797e97a268c606d0ba4160623bfa7ec0683c162fb8c578" => :yosemite
    sha256 "1c05ee4b3f609f81cd1507e22706befa2b78b945b8e2a7560d86e0a13746e845" => :mavericks
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.0.0-beta.1.tar.gz"
    sha256 "47191b7299562e0f25bdad28ad8be1d4fe09e6f7c40f50acc78455e3dc28da0c"
    version "1.0.0-beta.1"
  end

  depends_on "pkg-config" => :build
  depends_on "dmd" => :build

  def install
    ENV["GITVER"] = "1.0.0-beta.1" if build.devel?
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    system "#{bin}/dub; true"
  end
end
